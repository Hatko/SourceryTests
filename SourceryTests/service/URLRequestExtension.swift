//
//  URLRequestExtension.swift
//  Albert
//
//  Created by Kristoffer Arlefur on 2017-02-08.
//  Copyright © 2017 Visma. All rights reserved.
//

import Foundation

enum ContentType {
    case applicationJson
    case multipartFormData(boundary: String)

    var representation: String {
        switch self {
        case .applicationJson: return "application/json"
        case .multipartFormData(let boundary): return "multipart/form-data; boundary=\(boundary)"
        }
    }

    static var httpField: String { return "Content-Type" }
}

extension URLRequest {

    /**
     Custom initializer that sets some default HTTP headers used with eaccounting and economic APIs

     - parameter url: URL to the api endpoint
     - parameter method: HTTP method to be used
     - parameter data: Data that will be Serialized into a url query encoded string and set to the httpBody

     */
    init(url: URL, method: HttpMethod, data: Any? = nil) {
        self.init(url: url, method: method)

        httpBody = dataFrom(data) { return try JSONSerialization.data(withJSONObject: $0) }
    }

    init<T: Codable>(url: URL, method: HttpMethod, codable: T? = nil) {
        self.init(url: url, method: method)

        let encoder = JSONEncoder()
        httpBody = dataFrom(codable, dataBuilder: encoder.encode)
    }

    init(url: URL, method: HttpMethod, contentType: ContentType = .applicationJson) {
        self.init(url: url)

        httpMethod = method.rawValue

        addValue(contentType.representation, forHTTPHeaderField: ContentType.httpField)
    }

    func dataFrom<T>(_ data: T?, dataBuilder: (T) throws -> Data) -> Data? {
        guard let data = data else { return nil }

        do {
            return try dataBuilder(data)
        } catch {
        }

        return nil
    }
}
