//
//  RemoteMapper.swift
//  PackageData
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation

public final class RemoteMapper {
    private init() {}
    
    public static func map<T: Decodable>(
        _ data: Data,
        _ response: HTTPURLResponse,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {
        guard (200..<300).contains(response.statusCode) else {
            throw URLError(.init(rawValue: response.statusCode))
        }
        return try decoder.decode(T.self, from: data)
    }
}
