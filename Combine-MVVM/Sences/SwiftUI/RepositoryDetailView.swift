//
//  RepositoryDetailView.swift
//  Combine-MVVM
//
//  Created by Anh Nguyen on 11/07/2021.
//

import SwiftUI
import Combine

struct RepositoryDetailView: View {
    private var cancelBag = CancelBag()

    @ObservedObject var output: RepositoryDetailViewModel.Output
    
    private let loadTrigger = PassthroughSubject<Void, Never>()

    var body: some View {
        Text(output.repoName)
            .onAppear(perform: { loadTrigger.send(()) })
            .navigationBarTitle(output.repoName)
    }
    
    init(viewModel: RepositoryDetailViewModel) {
        let input = RepositoryDetailViewModel.Input(loadTrigger: loadTrigger.eraseToAnyPublisher())
        let output = viewModel.transform(input, cancelBag)
        self.output = output
    }
}
