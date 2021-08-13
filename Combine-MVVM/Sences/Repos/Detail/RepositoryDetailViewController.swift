//
//  RepositoryDetailViewController.swift
//  Combine-MVVM
//
//  Created by Anh Nguyen on 11/07/2021.
//

import UIKit
import Combine

final class RepositoryDetailViewController: UIViewController, BindableType {
    
    // MARK: - IBOutlets
    @IBOutlet weak var repoNameLabel: UILabel!
    
    // MARK: - Properties
    
    var viewModel: RepositoryDetailViewModel!
    private let cancelBag = CancelBag()

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
    }
    
    func bindViewModel() {
        let input = RepositoryDetailViewModel.Input(loadTrigger: Just(()).eraseToAnyPublisher())
        let output = viewModel.transform(input, cancelBag)
        
        output.$repoName.subscribe(repoNameSubscriber)
    }
}

// MARK: - Binders
extension RepositoryDetailViewController {
    private var repoNameSubscriber: Binder<String> {
        Binder(self) { (vc, name) in
            vc.title = name
            vc.repoNameLabel.text = name
        }
    }
}
