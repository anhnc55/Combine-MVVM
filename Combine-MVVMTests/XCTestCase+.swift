//
//  XCTestCase+.swift
//  Combine_MVVMTests
//
//  Created by Anh Nguyen on 09/07/2021.
//

import XCTest
import Combine

extension XCTestCase {
    func wait(timeout: TimeInterval = 1.0, completion: @escaping (() -> Void)) {
        let expectation = XCTestExpectation(description: self.debugDescription)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: timeout)
    }
}
