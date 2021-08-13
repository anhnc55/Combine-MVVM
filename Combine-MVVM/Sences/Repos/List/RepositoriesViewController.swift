//
//  RepositoriesViewController.swift
//  Combine-MVVM
//
//  Created by Anh Nguyen on 09/07/2021.
//

import UIKit
import Combine

final class RepositoriesViewController: UIViewController, BindableType {
    enum Section: Hashable {
        case main
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Properties
    var viewModel: RepositoriesViewModel!
    var cancelBag = CancelBag()
    
    private var dataSource: UITableViewDiffableDataSource<Section, Repository>! = nil
    
    private let searchTextTrigger = PassthroughSubject<String, Never>()
    private let selectRepoTrigger = PassthroughSubject<IndexPath, Never>()
    
    private var searchController: UISearchController!
    private var resultsController: UIViewController!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    private func configView() {
        navigationItem.title = "Repositories"
            
        tableView.register(ofType: RepoCell.self)
        tableView.delegate = self
        configureDataSource()
                
        searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.searchBar.isUserInteractionEnabled = false
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Repository>(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, repo: Repository) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(ofType: RepoCell.self, at: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.configCell(repo)
            return cell
        }
        dataSource.defaultRowAnimation = .fade
    }
    
    func bindViewModel() {
        let input = RepositoriesViewModel.Input(
            loadTrigger: Just(()).eraseToAnyPublisher(),
            searchTextTrigger: searchTextTrigger
                .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
                .eraseToAnyPublisher(),
            selectRepoTrigger: selectRepoTrigger.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input, cancelBag)
        
        output.$repos
            .subscribe(reposSubscriber)
        
        output.$error
            .dropFirst()
            .subscribe(errorSubscriber)
        
        output.$isLoading
            .subscribe(loadingSubscriber)
    }
}

// MARK: - Subscribers
extension RepositoriesViewController {
    private var reposSubscriber: Binder<[Repository]> {
        Binder(self) { (vc, repos) in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Repository>()
            snapshot.appendSections([.main])
            snapshot.appendItems(repos, toSection: .main)
            vc.dataSource.apply(snapshot, animatingDifferences: true)
            DispatchQueue.main.async {
                vc.tableView.isHidden = repos.isEmpty
            }
        }
    }
    
    private var loadingSubscriber: Binder<Bool> {
        Binder(self) { (vc, isLoading) in
            DispatchQueue.main.async {
                vc.activityIndicator.isHidden = !isLoading
                vc.searchController.searchBar.isUserInteractionEnabled = !isLoading
            }
        }
    }
    
    private var errorSubscriber: Binder<Error?> {
        Binder(self) { (vc, error) in
            guard let error = error else { return }
            vc.showError(error, completion: nil)
        }
    }
}

// MARK: - UITableViewDelegate
extension RepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchController.searchBar.endEditing(true)
        selectRepoTrigger.send(indexPath)
    }
}

// MARK: - UISearchBarDelegate
extension RepositoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextTrigger.send(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTextTrigger.send("")
    }
}

// MARK: - UIScrollViewDelegate
extension RepositoriesViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
}
