//
//  HTTPClient.swift
//  PackageData
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation

public protocol HTTPClient: Sendable {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func get(
        from url: URL,
        headers: [String: String]?,
        completion: @escaping @Sendable (Result) -> Void
    ) -> HTTPClientTask
}

public extension HTTPClient {
    func get(
        from url: URL,
        headers: [String: String]? = nil
    ) async throws -> (Data, HTTPURLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            get(from: url, headers: headers) { result in
                continuation.resume(with: result)
            }
        }
    }
}

