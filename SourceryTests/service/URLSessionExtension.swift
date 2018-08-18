//
//  URLSessionExtension.swift
//  Albert
//
//  Created by Kristoffer Arlefur on 2017-02-07.
//  Copyright © 2017 Visma. All rights reserved.
//

import Foundation
import PromiseKit

enum STError: Error {
    case badHttpResponse
    case accessDenied
    case unsuccessful(statusCode: Int, data: Data?)
    case missingData
    case invalidResponse
}

typealias DataCompletion = (Data?, Error?) -> Void

struct UploaderSettings {
    var additionalHeaders: [String: String] = [:]
    var settings: [String: String] = [:]
    var filename: String = "image.jpg"
    var contentType: String = "image/jpg"
}

enum HttpMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
    case OPTIONS
    case HEAD
}

protocol URLSessionProtocol {
    func upload(url: URL, data: Data, settings: UploaderSettings) -> Promise<Data>
    func post(url: URL, data: Any?, additionalHeaders: [String: String]?) -> Promise<Data>
    func post<T: Codable>(url: URL, codable: T?, additionalHeaders: [String: String]?) -> Promise<Data>
    func get(url: URL, additionalHeaders: [String: String]?) -> Promise<Data>
    func put(url: URL, data: Any?, additionalHeaders: [String: String]?) -> Promise<Data>
    func put<T: Codable>(url: URL, codable: T?, additionalHeaders: [String: String]?) -> Promise<Data>
    func patch(url: URL, data: Any?, additionalHeaders: [String: String]?) -> Promise<Data>
    func delete(url: URL, data: Any?, additionalHeaders: [String: String]?) -> Promise<Data>

    // Default URLSession functions
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void
    ) -> URLSessionDataTask

    var configuration: URLSessionConfiguration { get }
}

extension URLSessionProtocol {
    func upload(url: URL, data: Data, settings: UploaderSettings = UploaderSettings()) -> Promise<Data> {
        return upload(url: url, data: data, settings: settings)
    }

    func post(url: URL, data: Any? = nil, additionalHeaders: [String: String]? = nil) -> Promise<Data> {
        return post(url: url, data: data, additionalHeaders: additionalHeaders)
    }

    func post<T: Codable>(url: URL, codable: T? = nil, additionalHeaders: [String: String]? = nil) -> Promise<Data> {
        return post(url: url, codable: codable, additionalHeaders: additionalHeaders)
    }

    func get(url: URL, additionalHeaders: [String: String]? = nil) -> Promise<Data> {
        return get(url: url, additionalHeaders: additionalHeaders)
    }

    func put(url: URL, data: Any? = nil, additionalHeaders: [String: String]? = nil) -> Promise<Data> {
        return put(url: url, data: data, additionalHeaders: additionalHeaders)
    }

    func patch(url: URL, data: Any? = nil, additionalHeaders: [String: String]? = nil) -> Promise<Data> {
        return patch(url: url, data: data, additionalHeaders: additionalHeaders)
    }

    func delete(url: URL,
                data: Any? = nil,
                additionalHeaders: [String: String]? = nil) -> Promise<Data> {
        return delete(url: url, data: data, additionalHeaders: additionalHeaders)
    }

    func put<T: Codable>(url: URL, codable: T? = nil, additionalHeaders: [String: String]? = nil) -> Promise<Data> {
        return put(url: url, codable: codable, additionalHeaders: additionalHeaders)
    }
}

extension URLSession: URLSessionProtocol {

    /**

     Sends a **POST** to the specified url

     - parameter url: The url
     - parameter data: Data that will be set to the httpBody
     - parameter additionalHeaders: Additional headers to be set in the HTTP request

     - returns: A Promise with the returned data

     */
    func post(url: URL, data: Any?, additionalHeaders: [String: String]?) -> Promise<Data> {
        return dataTask(url: url, method: .POST, data: data, additionalHeaders: additionalHeaders)
    }

    func post<T: Codable>(url: URL, codable: T?, additionalHeaders: [String: String]?) -> Promise<Data> {
        return dataTask(url: url, method: .POST, codable: codable, additionalHeaders: additionalHeaders)
    }

    /**

     Sends a **GET** to the specified Path

     - parameter url: The url
     - parameter data: Data that will be set to the httpBody
     - parameter additionalHeaders: Additional headers to be set in the HTTP request

     - returns: A Promise with the returned data

     */
    func get(url: URL, additionalHeaders: [String: String]?) -> Promise<Data> {
        return dataTask(url: url, method: .GET, additionalHeaders: additionalHeaders)
    }

    /**

     Sends a **PUT** to the specified Path

     - parameter url: The url
     - parameter data: Data that will be set to the httpBody
     - parameter additionalHeaders: Additional headers to be set in the HTTP request

     - returns: A Promise with the returned data

     */
    func put(url: URL, data: Any?, additionalHeaders: [String: String]?) -> Promise<Data> {
        return dataTask(url: url, method: .PUT, data: data, additionalHeaders: additionalHeaders)
    }

    func put<T: Codable>(url: URL, codable: T?, additionalHeaders: [String: String]?) -> Promise<Data> {
        return dataTask(url: url, method: .PUT, codable: codable, additionalHeaders: additionalHeaders)
    }

    /**

     Sends a **PATCH** to the specified Path

     - parameter url: The url
     - parameter data: Data that will be set to the httpBody
     - parameter additionalHeaders: Additional headers to be set in the HTTP request

     - returns: A Promise with the returned data

     */
    func patch(url: URL, data: Any?, additionalHeaders: [String: String]?) -> Promise<Data> {
        return dataTask(url: url, method: .PATCH, data: data, additionalHeaders: additionalHeaders)
    }

    /**

     Sends a **DELETE** to the specified Path

     - parameter url: The url
     - parameter data: Data that will be set to the httpBody
     - parameter additionalHeaders: Additional headers to be set in the HTTP request

     - returns: A Promise with the returned data

     */
    func delete(url: URL, data: Any?, additionalHeaders: [String: String]?) -> Promise<Data> {
        return dataTask(url: url, method: .DELETE, data: data, additionalHeaders: additionalHeaders)
    }

    func upload(url: URL, data: Data, settings: UploaderSettings) -> Promise<Data> {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url, method: HttpMethod.POST, contentType: .multipartFormData(boundary: boundary))
        request.httpBody = multipartFormData(boundary: boundary, settings: settings, data: data)

        return dataTask(request: request)
    }

    private func multipartFormData(boundary: String, settings: UploaderSettings, data: Data) -> Data {
        var body = Data()
        body.append(string: "--\(boundary)\r\n")
        body.append(string: "Content-Disposition: form-data; name=\"file\"; filename=\"\(settings.filename)\"\r\n")
        body.append(string: "Content-Type: \(settings.contentType)\r\n\r\n")
        body.append(data)
        body.append(string: "\r\n")

        body.append(string: "--\(boundary)--\r\n")
        return body
    }

    func uploadSmartScanData(url: URL, data: Data, settings: UploaderSettings = UploaderSettings()) -> Promise<Data> {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url, method: HttpMethod.POST, contentType: .multipartFormData(boundary: boundary))

        var body = Data()
        body.append(string: "--\(boundary)\r\n")
        body.append(string: "Content-Disposition: form-data; name=\"document\"\r\n\r\n")
        body.append(string: "{\"Pages\": [{ \"ContentType\": \"\(settings.contentType)\" }],")

        if settings.settings.count > 0 {
            body.append(string: "\"Settings\": {")
            body.append(string: settings.settings.map({"\"\($0.key)\":\"\($0.value)\""}).joined(separator: ","))
            body.append(string: "}")
        }

        body.append(string: "}\r\n")

        body.append(multipartFormData(boundary: boundary, settings: settings, data: data))

        request.httpBody = body

        return dataTask(request: request)
    }

    /**

     Data task function that exectues an URLRequest

     - parameter url: The url
     - parameter method: HTTP method to use in the call
     - parameter data: Data that will be set to the httpBody
     - parameter additionalHeaders: Additional headers to be set in the HTTP request

     - returns: A Promise with the returned data

     */
    internal func dataTask(url: URL,
                           method: HttpMethod,
                           data: Any? = nil,
                           additionalHeaders: [String: String]? = nil) -> Promise<Data> {
        return dataTask(request: URLRequest(url: url, method: method, data: data), additionalHeaders: additionalHeaders)
    }

    internal func dataTask<T: Codable>(
            url: URL,
            method: HttpMethod,
            codable: T?,
            additionalHeaders: [String: String]? = nil) -> Promise<Data> {
        return dataTask(
                request: URLRequest(url: url, method: method, codable: codable),
                additionalHeaders: additionalHeaders
        )
    }

#if TESTING
    internal func dataTask(request: URLRequest, additionalHeaders: [String: String]? = nil) -> Promise<Data> {
        fatalError("This shouldn't get called from the tests!")
    }
#else
    internal func dataTask(request: URLRequest, additionalHeaders: [String: String]? = nil) -> Promise<Data> {
        var request = request

        additionalHeaders?.forEach { header, value in
            request.addValue(value, forHTTPHeaderField: header)
        }

        return Promise { seal in
            let now = Date().timeIntervalSince1970
            self.dataTask(with: request) { (data, response, error) in
                let responseTime = Date().timeIntervalSince1970 - now

                if let error = error {
                    seal.reject(error)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    seal.reject(STError.badHttpResponse)
                    return
                }

                self.logResponse(response, responseTime: responseTime, request: request)
                if response.statusCode == 401 {
                    seal.reject(STError.accessDenied)
                    return
                }

                guard 200...299 ~= response.statusCode else {
                    seal.reject(STError.unsuccessful(statusCode: response.statusCode, data: data))
                    return
                }
                guard let data = data else {
                    seal.reject(STError.missingData)
                    return
                }

                seal.fulfill(data)
            }.resume()
        }
    }
#endif

    private func logResponse(_ response: HTTPURLResponse, responseTime: Double, request: URLRequest) {
        let parts: [String] = [
            request.httpMethod ?? "(no method)",
            "\(response.statusCode)",
            response.url?.description ?? "(no url)",
            String(format: "%.2fms", (responseTime * 1000))
        ]

    }
}

extension Data {
    mutating func append(string: String, using encoding: String.Encoding = .utf8) {
        let data = string.data(using: encoding)
        append(data!)
    }
}

