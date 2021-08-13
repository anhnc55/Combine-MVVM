//
//  RepositoriesUseCase.swift
//  Combine-MVVM
//
//  Created by Anh Nguyen on 09/07/2021.
//
import Combine

protocol RepositoriesUseCaseType {
    func getRepositories(query: String?) -> AnyPublisher<[Repository], APIError>
}

struct RepositoriesUseCase: RepositoriesUseCaseType {
    func getRepositories(query: String?) -> AnyPublisher<[Repository], APIError> {
        Repository
            .searchRepositories(query: query)
            .map { $0.items ?? [] }
            .eraseToAnyPublisher()
    }
}
