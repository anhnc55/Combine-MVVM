//
//  Repo+Networking.swift
//  Combine-MVVM
//
//  Created by Anh Nguyen on 10/07/2021.
//

import Combine
final class RepositoryResponse: Decodable {
    private(set) var items: [Repository]?    
}

extension Repository {
    static func searchRepositories(query: String?) -> AnyPublisher<RepositoryResponse, APIError> {
        var searchText = "Combine"
        if let query = query, !query.isEmpty {
            searchText = query
        }
        return API.shared
            .request(endpoint: .searchRepos,
                     params: ["q": searchText, "order": "desc"])
            .eraseToAnyPublisher()
    }
}
