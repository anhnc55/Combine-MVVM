//
//  RepositoriesViewModelTests.swift
//  Combine_MVVMTests
//
//  Created by Anh Nguyen on 09/07/2021.
//

@testable import Combine_MVVM
import XCTest
import Combine

final class RepositoriesViewModelTests: XCTestCase {
    private var viewModel: RepositoriesViewModel!
    private var navigator: RepositoriesNavigatorMock!
    private var useCase: RepositoriesUseCaseMock!
    
    private var input: RepositoriesViewModel.Input!
    private var output: RepositoriesViewModel.Output!
    
    private var cancelBag: CancelBag!
    
    private let loadTrigger = PassthroughSubject<Void, Never>()
    private let selectRepoTrigger = PassthroughSubject<IndexPath, Never>()
    private let searchTextTrigger = PassthroughSubject<String, Never>()
    
    override func setUp() {
        super.setUp()
        navigator = RepositoriesNavigatorMock()
        useCase = RepositoriesUseCaseMock()
        cancelBag = CancelBag()
        viewModel = RepositoriesViewModel(navigator: navigator, useCase: useCase)
        
        input = RepositoriesViewModel.Input(loadTrigger: loadTrigger.eraseToAnyPublisher(),
                                            searchTextTrigger: searchTextTrigger.eraseToAnyPublisher(),
                                            selectRepoTrigger: selectRepoTrigger.eraseToAnyPublisher())
        output = viewModel.transform(input, cancelBag)
    }
    
    func test_load_repoList_success() {
        loadTrigger.send(())
        
        wait {
            XCTAssert(self.useCase.getRepositoriesCalled)
        }
    }
}
