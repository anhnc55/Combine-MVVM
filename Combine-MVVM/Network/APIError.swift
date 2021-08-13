import Foundation
import Combine

struct APIResponseError: Decodable {
    let message: String?
    let error: Int?
    
    static func processResponseError(error: APIError) -> APIResponseError {
        switch error {
        case let .responseError(error, _):
            return error
        default:
            return APIResponseError(message: "Unknown error", error: -999)
        }
    }
}

enum APIError: Error {
    case unknown(data: Data)
    case message(reason: String, data: Data)
    case parseError(reason: Error)
    case responseError(error: APIResponseError, data: Data)
}
