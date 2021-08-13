//
//  RepositoriesViewControllerTests.swift
//  Combine-MVVMTests
//
//  Created by Anh Nguyen on 09/07/2021.
//

@testable import Combine_MVVM
import XCTest

final class RepositoriesViewControllerTests: XCTestCase {
    var viewController: RepositoriesViewController!
    
    override func setUp() {
        super.setUp()
        viewController = Storyboards.main.instantiateViewController(ofType: RepositoriesViewController.self)
        viewController.viewModel = RepositoriesViewModel(navigator: RepositoriesNavigatorMock(),
                                                     useCase: RepositoriesUseCaseMock())
    }
    
    func test_ibOutlets() {
        _ = viewController.view
        XCTAssertNotNil(viewController.tableView)
        XCTAssertNotNil(viewController.activityIndicator)
    }
}
