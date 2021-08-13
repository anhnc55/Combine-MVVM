//
//  RepositoriesNavigator.swift
//  Combine-MVVM
//
//  Created by Anh Nguyen on 09/07/2021.
//

import UIKit

protocol RepositoriesNavigatorType {
    func toRepoDetail(repo: Repository)
}

struct RepositoriesNavigator: RepositoriesNavigatorType {
    let navigationController: UINavigationController
    
    func toRepoDetail(repo: Repository) {
        let repoDetailVC = AppRoute.createRepositoryDetailViewController(navi: navigationController,
                                                                         repo: repo)
        navigationController.pushViewController(repoDetailVC, animated: true)
    }
}
