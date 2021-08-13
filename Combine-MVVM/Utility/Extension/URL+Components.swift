//
//  URL+.swift
//  Combine-MVVM
//
//  Created by Anh Nguyen on 10/07/2021.
//

import Foundation

extension URL {
    func appending(_ queryItem: String, value: String?) -> URL {
        guard var components = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = components.queryItems ??  []
        let queryItem = URLQueryItem(name: queryItem, value: value)
        queryItems.append(queryItem)
        components.queryItems = queryItems
        return components.url!
    }
    
    var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }

}
