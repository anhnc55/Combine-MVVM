import Foundation
import Combine

class API {
    static let shared = API()
    static private let BASE_URL = "https://api.github.com/"
    
    private var session: URLSession
    private let decoder: JSONDecoder
    
    private var oauthStateCancellable: AnyCancellable?
    
    init() {
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        session = URLSession(configuration: Self.makeSessionConfiguration())
    }
    
    static private func makeSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        let headers = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json"
        ]
        configuration.httpAdditionalHeaders = headers
        configuration.urlCache = .shared
        configuration.requestCachePolicy = .reloadRevalidatingCacheData
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        return configuration
    }
    
    static private func makeURL(endpoint: Endpoint) -> URL {
        let url = URL(string: BASE_URL)?.appendingPathComponent(endpoint.path())
        let component = URLComponents(url: url!, resolvingAgainstBaseURL: false)!
        return component.url!
    }
    
    static private func makeRequest(url: URL,
                                    httpMethod: String = "GET",
                                    params: [String: String]? = nil) -> URLRequest {
        var request: URLRequest
        var url = url
        if let params = params {
            if httpMethod != "GET" {
                var urlComponents = URLComponents()
                urlComponents.queryItems = []
                for (_, param) in params.enumerated() {
                    urlComponents.queryItems?.append(URLQueryItem(name: param.key, value: param.value))
                }
                request = URLRequest(url: url)
                request.httpBody = urlComponents.percentEncodedQuery?.data(using: .utf8)
                // request.setValue("application/x-www-form-urlencoded",forHTTPHeaderField: "Content-Type")
            } else {
                for (_, value) in params.enumerated() {
                    url = url.appending(value.key, value: value.value)
                }
                request = URLRequest(url: url)
            }
        } else {
            request = URLRequest(url: url)
        }
        request.httpMethod = httpMethod
        return request
    }
    
    func request<T: Decodable>(endpoint: Endpoint,
                               httpMethod: String = "GET",
                               params: [String: String]? = nil) -> AnyPublisher<T ,APIError> {
        let url = Self.makeURL(endpoint: endpoint)
        let request = Self.makeRequest(url: url,
                                       httpMethod: httpMethod,
                                       params: params)
        return executeRequest(publisher: session.dataTaskPublisher(for: request))
    }
    
    func POST(endpoint: Endpoint,
              isJSONEndpoint: Bool = true,
              params: [String: String]? = nil) -> AnyPublisher<NetworkResponse, Never> {
        request(endpoint: endpoint,
                httpMethod: "POST",
                params: params)
            .subscribe(on: DispatchQueue.global())
            .catch { Just(NetworkResponse(error: APIResponseError.processResponseError(error: $0))) }
            .eraseToAnyPublisher()
    }
    
    private func executeRequest<T: Decodable>(publisher: URLSession.DataTaskPublisher) -> AnyPublisher<T, APIError> {
        publisher
            .tryMap { data, response in
                try self.processResponse(data: data, response: response)
            }
            .handleEvents(receiveOutput: {
                do{
                    _ = try JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any]
                } catch {
                    print(error.localizedDescription)
                }
            })
            .decode(type: T.self, decoder: decoder)
            .mapError {
                APIError.parseError(reason: $0)
            }
            .eraseToAnyPublisher()
    }
    
    private func processResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown(data: data)
        }
        if (httpResponse.statusCode == 404) {
            throw APIError.message(reason: "Resource not found", data: data)
        }
        if 200 ... 299 ~= httpResponse.statusCode {
            return data
        } else {
            do {
                let error = try decoder.decode(APIResponseError.self, from: data)
                throw APIError.responseError(error: error, data: data)
            } catch {
                throw APIError.unknown(data: data)
            }
        }
    }
}
