//
//  RepositoriesView.swift
//  Combine-MVVM
//
//  Created by Anh Nguyen on 09/07/2021.
//

import SwiftUI
import Combine

struct RepositoriesView : View {
    private var cancelBag = CancelBag()
    @State var searchText = ""
    
    @ObservedObject var output: RepositoriesViewModel.Output
    
    private let loadTrigger = PassthroughSubject<Void, Never>()
    private let selectRepoTrigger = PassthroughSubject<IndexPath, Never>()
    private let searchTextTrigger = PassthroughSubject<String, Never>()
    
    var body: some View {
        SearchNavigation(text: $searchText, search: search, cancel: cancel) {
            ZStack {
                List(output.repos) { repository in
                    RepositoriesRow(repository: repository)
                }
                .navigationBarTitle("Repositories")
                ActivityIndicator(isAnimating: output.isLoading)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear(perform: { self.loadTrigger.send(()) })
    }
    
    init(viewModel: RepositoriesViewModel) {
        let input = RepositoriesViewModel.Input(loadTrigger: loadTrigger.eraseToAnyPublisher(),
                                                searchTextTrigger: searchTextTrigger
                                                    .throttle(for: 0.5,
                                                                 scheduler: RunLoop.main,
                                                                 latest: true)
                                                    .eraseToAnyPublisher(),
                                                selectRepoTrigger: selectRepoTrigger.eraseToAnyPublisher())
        let output = viewModel.transform(input, cancelBag)
        self.output = output
    }
    
    func search() {
        searchTextTrigger.send(searchText)
    }
    
    func cancel() {
        searchTextTrigger.send("")
    }
}

