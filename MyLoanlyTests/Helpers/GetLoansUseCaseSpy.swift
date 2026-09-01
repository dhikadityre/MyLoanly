//
//  GetLoansUseCaseSpy.swift
//  MyLoanlyTests
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation
import CoreDomain

final class GetLoansUseCaseSpy: GetLoansUseCase, @unchecked Sendable {
    private(set) var executeCallCount: Int = 0
    var result: Result<[Loan], Error>
    
    init(result: Result<[Loan], Error> = .success([])) {
        self.result = result
    }
    
    func execute() async throws -> [Loan] {
        executeCallCount += 1
        return try result.get()
    }
}
