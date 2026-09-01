//
//  GetLoansUseCase.swift
//  CoreDomain
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation

public protocol GetLoansUseCase {
    func execute() async throws -> [Loan]
}

public final class GetLoansUseCaseImpl: GetLoansUseCase {
    private let repository: CoreRepository

    public init(repository: CoreRepository) {
        self.repository = repository
    }

    public func execute() async throws -> [Loan] {
        try await repository.getLoans()
    }
}
