//
//  GetLoansUseCase.swift
//  CoreDomain
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import XCTest
@testable import CoreDomain

final class GetLoansUseCaseTests: XCTestCase {
    
    func test_execute_requestsDataFromRepository() async throws {
        let repository = CoreRepositorySpy()
        let sut = GetLoansUseCaseImpl(repository: repository)
        
        _ = try? await sut.execute()
        
        XCTAssertEqual(repository.getLoansCallCount, 1)
    }
    
    func test_execute_deliversLoansOnRepositorySuccess() async throws {
        let expectedLoans = [makeLoan()]
        let repository = CoreRepositorySpy(result: .success(expectedLoans))
        let sut = GetLoansUseCaseImpl(repository: repository)
        
        let loans = try await sut.execute()
        
        XCTAssertEqual(loans.count, expectedLoans.count)
        XCTAssertEqual(loans.first?.id.value, expectedLoans.first?.id.value)
    }
    
    func test_execute_deliversErrorOnRepositoryFailure() async throws {
        let expectedError = NSError(domain: "any error", code: 0)
        let repository = CoreRepositorySpy(result: .failure(expectedError))
        let sut = GetLoansUseCaseImpl(repository: repository)
        
        do {
            _ = try await sut.execute()
            XCTFail("Expected error, got success instead")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    // MARK: - Helpers
    
    private final class CoreRepositorySpy: CoreRepository {
        var getLoansCallCount = 0
        private let result: Result<[Loan], Error>
        
        init(result: Result<[Loan], Error> = .success([])) {
            self.result = result
        }
        
        func getLoans() async throws -> [Loan] {
            getLoansCallCount += 1
            return try result.get()
        }
    }
    
    private func makeLoan() -> Loan {
        return Loan(
            id: LoanID(value: "1"),
            amount: Money(amount: 1000),
            interestRate: Percentage(value: 0.05),
            term: LoanTerm(days: 30),
            purpose: .businessExpansion,
            riskRating: .a,
            borrower: Borrower(
                id: BorrowerID(value: "borrower-1"),
                name: "John Doe",
                email: "john@example.com",
                creditScore: 750
            ),
            collateral: Collateral(
                type: .realEstate,
                value: Money(amount: 2000)
            ),
            documents: [],
            repaymentSchedule: RepaymentSchedule(
                installments: []
            )
        )
    }
}
