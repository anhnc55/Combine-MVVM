//
//  AppRoute.swift
//  Combine-MVVM
//
//  Created by Anh Nguyen on 09/07/2021.
//

import UIKit
import SwiftUI

class AppRoute {
    static func createRepositoriesViewController(navi: UINavigationController) -> UIViewController {
        let storyboard = Storyboards.main
        let viewController = storyboard.instantiateViewController(ofType: RepositoriesViewController.self)
        let navigator = RepositoriesNavigator(navigationController: navi)
        let useCase = RepositoriesUseCase()
        let viewModel = RepositoriesViewModel(navigator: navigator, useCase: useCase)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    static func createRepositoryDetailViewController(navi: UINavigationController,
                                                     repo: Repository) -> UIViewController {
        let storyboard = Storyboards.main
        let viewController = storyboard.instantiateViewController(ofType: RepositoryDetailViewController.self)
        let navigator = RepositoryDetailNavigator(navigationController: navi)
        let useCase = RepositoryDetailUseCase()
        let viewModel = RepositoryDetailViewModel(navigator: navigator,
                                                  useCase: useCase,
                                                  repo: repo)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    static func createRepositoriesView(navi: UINavigationController) -> UIViewController {
        let navigator = RepositoriesNavigator(navigationController: navi)
        let useCase = RepositoriesUseCase()
        let viewModel = RepositoriesViewModel(navigator: navigator, useCase: useCase)

        let repositoriesView = RepositoriesView(viewModel: viewModel)

        let controller = UIHostingController(rootView: repositoriesView)
        return controller
    }
    
    static func configureMainInterface() -> UITabBarController {
        let uiKitNavi = UINavigationController()
        let uiKitVC = AppRoute.createRepositoriesViewController(navi: uiKitNavi)
        uiKitNavi.viewControllers = [uiKitVC]
        uiKitNavi.tabBarItem = UITabBarItem(title: "UIKit",
                                            image: UIImage(systemName: "square.stack.3d.up"),
                                            selectedImage: UIImage(systemName: "square.stack.3d.up.fill"))
        
        let createRepositoriesView = AppRoute.createRepositoriesView(navi: UINavigationController())
        createRepositoriesView.tabBarItem = UITabBarItem(title: "SwiftUI",
                                                         image: UIImage(systemName: "swift"),
                                                         selectedImage: nil)
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            uiKitNavi,
            createRepositoriesView
        ]
        return tabBarController
    }
}
