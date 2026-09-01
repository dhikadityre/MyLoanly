//
//  APIClient.swift
//  PackageData
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    private func execute(
        _ request: URLRequest,
        completion: @escaping @Sendable (HTTPClient.Result) -> Void
    ) -> HTTPClientTask {
        let task = session.dataTask(with: request) { data, response, error in
            completion(Swift.Result {
                if let error = error { throw error }
                guard let data = data, let response = response as? HTTPURLResponse else {
                    throw UnexpectedValuesRepresentation()
                }
                return (data, response)
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
    
    @discardableResult
    public func get(
        from url: URL,
        headers: [String: String]?,
        completion: @escaping @Sendable (HTTPClient.Result) -> Void
    ) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return execute(request, completion: completion)
    }
    
    @discardableResult
    public func post(
        to url: URL,
        data: Data?,
        headers: [String: String]?,
        completion: @escaping @Sendable (HTTPClient.Result) -> Void
    ) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpBody = data
        return execute(request, completion: completion)
    }
}
