//
//  RepositoriesUseCaseMock.swift
//  Combine_MVVMTests
//
//  Created by Anh Nguyen on 09/07/2021.
//

@testable import Combine_MVVM
import Combine

final class RepositoriesUseCaseMock: RepositoriesUseCaseType {
    var getRepositoriesCalled = false
    var getRepositoriesReturnValue = Future<[Repository], APIError> { promise in
        promise(.success([]))
    }
    .eraseToAnyPublisher()
    func getRepositories(query: String?) -> AnyPublisher<[Repository], APIError> {
        getRepositoriesCalled = true
        return getRepositoriesReturnValue
    }
}
