//
//  RepositoryDetailViewModel.swift
//  Combine-MVVM
//
//  Created by Anh Nguyen on 11/07/2021.
//

import Combine
import Foundation

struct RepositoryDetailViewModel {
    let navigator: RepositoryDetailNavigatorType
    let useCase: RepositoryDetailUseCaseType
    let repo: Repository
}

// MARK: - ViewModelType
extension RepositoryDetailViewModel: ViewModelType {
    struct Input {
        let loadTrigger: AnyPublisher<Void, Never>
    }
    
    final class Output: ObservableObject {
       @Published var repoName: String = ""
    }
    
    func transform(_ input: Input,_ cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.loadTrigger
            .map { self.repo.name ?? "" }
            .assign(to: \.repoName, on: output)
            .store(in: cancelBag)
        
        return output
    }
}
