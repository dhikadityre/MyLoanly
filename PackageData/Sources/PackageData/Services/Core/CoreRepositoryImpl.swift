//
//  CoreRepositoryImpl.swift
//  PackageData
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation
import CoreDomain

public class CoreRepositoryImpl: CoreRepository {
    private let client: HTTPClient
    private let baseURL: URL
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    public init(
        client: HTTPClient,
        baseURL: URL,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.client = client
        self.baseURL = baseURL
        self.decoder = decoder
        self.encoder = encoder
    }

    
    public func getLoans() async throws -> [Loan] {
        let url = baseURL.appendingPathComponent("/andreascandle/p2p_json_test/main/api/json/loans.json")
        let (data, response) = try await client.get(from: url)
        let dto: [LoanDTO] = try RemoteMapper.map(data, response, decoder: decoder)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dto.map { $0.toDomain(dateFormatter: dateFormatter) }
    }
}
