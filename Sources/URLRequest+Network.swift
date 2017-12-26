/**
 *  https://github.com/tadija/AENetwork
 *  Copyright (c) Marko Tadić 2017
 *  Licensed under the MIT license. See LICENSE file.
 */

import Foundation

extension URLRequest {

    // MARK: Types

    public enum Method: String {
        case get, post, put, delete
    }

    // MARK: Init

    public init(url: URL,
         method: Method,
         headers: [String : String]? = nil,
         urlParameters: [String : Any]? = nil,
         body: [String : Any]? = nil)
    {
        if let urlParameters = urlParameters, let urlWithParameters = url.addingParameters(urlParameters) {
            self.init(url: urlWithParameters)
        } else {
            self.init(url: url)
        }
        httpMethod = method.rawValue.capitalized
        allHTTPHeaderFields = headers
        if let body = body {
            httpBody = try? Data(jsonWith: body)
        }
    }

    // MARK: API / Factory

    public static func get(url: URL, headers: [String : String]? = nil, parameters: [String : Any]? = nil) -> URLRequest {
        return URLRequest(url: url, method: .get, headers: headers, urlParameters: parameters)
    }

    public static func post(url: URL, headers: [String : String]? = nil, parameters: [String : Any]? = nil) -> URLRequest {
        return URLRequest(url: url, method: .post, headers: headers, body: parameters)
    }

    public static func put(url: URL, headers: [String : String]? = nil, parameters: [String : Any]? = nil) -> URLRequest {
        return URLRequest(url: url, method: .put, headers: headers, body: parameters)
    }

    public static func delete(url: URL, headers: [String : String]? = nil, parameters: [String : Any]? = nil) -> URLRequest {
        return URLRequest(url: url, method: .delete, headers: headers, body: parameters)
    }

    // MARK: API / Fetch

    public func perform(with network: Network = .shared, completion: @escaping Fetcher.Completion.ThrowableResult) {
        network.performRequest(self, completion: completion)
    }

}
