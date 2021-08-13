//
//  RepositoriesNavigatorMock.swift
//  Combine_MVVMTests
//
//  Created by Anh Nguyen on 09/07/2021.
//

@testable import Combine_MVVM

final class RepositoriesNavigatorMock: RepositoriesNavigatorType {
    var toRepoDetailCalled = false
    func toRepoDetail(repo: Repository) {
        toRepoDetailCalled = true
    }
}
