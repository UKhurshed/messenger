//
//  APIRequest.swift
//  messenger
//
//  Created by Khurshed Umarov on 15.12.2022.
//

import Foundation


struct APIConstants {
    static let scheme: String = "http"
    static let hostURL: String = ""
}

struct APIRequest {
    let path: String
    let params: [String: String]
    let scheme: HTTPScheme
    let host: String
    let httpMethod: HTTPMethod
    
    init(path: String, params: [String: String], scheme: HTTPScheme = .http, host: String, httpMethod: HTTPMethod = .get) {
        self.path = path
        self.params = params
        self.scheme = scheme
        self.host = host
        self.httpMethod = httpMethod
    }
    
    var url: URL? {
        var components = URLComponents()
        components.path = path
        components.host = host
        components.scheme = scheme.rawValue
        components.setQueryItems(with: params)
        return components.url
    }
    
    public func getURLRequest() throws -> URLRequest {
        guard let url = url else {
            throw CustomError.urlRequestNull
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.description
        return urlRequest
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}


enum HTTPMethod: String, CustomStringConvertible {
    case get
    case post
    case put
    case delete
    
    public var description: String {
        rawValue.uppercased()
    }
}

enum HTTPScheme: String, CustomStringConvertible {
    case http
    case https
    
    public var description: String {
        rawValue
    }
}
