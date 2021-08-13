//
//  AppError.swift
//  Combine-MVVM
//
//  Created by Anh Nguyen on 09/07/2021.
//

import Foundation

enum AppError: LocalizedError {
    case none
    case error(message: String)

    var errorDescription: String? {
        switch self {
        case let .error(message):
            return message
        default:
            return ""
        }
    }
}
