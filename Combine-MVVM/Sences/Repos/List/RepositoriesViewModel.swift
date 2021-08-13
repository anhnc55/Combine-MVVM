//
//  RepositoriesViewModel.swift
//  Combine-MVVM
//
//  Created by Anh Nguyen on 09/07/2021.
//

import Foundation
import Combine

struct RepositoriesViewModel {
    let navigator: RepositoriesNavigatorType
    let useCase: RepositoriesUseCaseType
}

// MARK: - ViewModelType
extension RepositoriesViewModel: ViewModelType {
    struct Input {
        let loadTrigger: AnyPublisher<Void, Never>
        let searchTextTrigger: AnyPublisher<String, Never>
        let selectRepoTrigger: AnyPublisher<IndexPath, Never>
    }
    
    final class Output: ObservableObject {
        @Published var repos = [Repository]()
        @Published var isLoading = false
        @Published var error: Error?
    }
    
    func transform(_ input: Input, _ cancelBag: CancelBag) -> Output {
        let output = Output()
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityTracker(false)

        input.loadTrigger
            .flatMap {
                self.useCase
                    .getRepositories(query: nil)
                    .trackError(errorTracker)
                    .trackActivity(activityTracker)
                    .catch { _ in Empty() }
                    .eraseToAnyPublisher()
            }
            .assign(to: \.repos, on: output)
            .store(in: cancelBag)

        input.searchTextTrigger
            .flatMap {
                self.useCase
                    .getRepositories(query: $0)
                    .catch { _ in Empty() }
                    .eraseToAnyPublisher()
            }
            .assign(to: \.repos, on: output)
            .store(in: cancelBag)

        input.selectRepoTrigger
            .sink(receiveValue: {
                let repo = output.repos[$0.row]
                self.navigator.toRepoDetail(repo: repo)
            })
            .store(in: cancelBag)

        activityTracker
            .assign(to: \.isLoading, on: output)
            .store(in: cancelBag)
        
        errorTracker
            .receive(on: RunLoop.main)
            .mapToOptional()
            .assign(to: \.error, on: output)
            .store(in: cancelBag)
        
        return output
    }
}
