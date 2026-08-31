//
//  GetLoansUseCase.swift
//  CoreDomain
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import XCTest
import os
import CoreDomain
@testable import PackageData

final class CoreRepositoryImplTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_getLoans_requestsDataFromURL() async {
        let baseURL = URL(string: "https://any-url.com")!
        let (sut, client) = makeSUT(baseURL: baseURL)
        let expectedURL = baseURL.appendingPathComponent("/andreascandle/p2p_json_test/main/api/json/loans.json")
        client.stub(statusCode: 200, data: emptyListJSON())
        
        _ = try? await sut.getLoans()
        
        XCTAssertEqual(client.requestedURLs, [expectedURL])
    }
    
    func test_getLoans_failsOnClientError() async {
        let (sut, client) = makeSUT()
        let expectedError = NSError(domain: "client error", code: 0)
        client.stub(with: expectedError)
        
        do {
            _ = try await sut.getLoans()
            XCTFail("Expected error, got success instead")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_getLoans_failsOnNon200HTTPResponse() async {
        let samples = [199, 300, 400, 500]
        
        for code in samples {
            let (sut, client) = makeSUT()
            client.stub(statusCode: code, data: emptyListJSON())
            
            do {
                _ = try await sut.getLoans()
                XCTFail("Expected failure on HTTP status code \(code)")
            } catch {
                XCTAssertNotNil(error)
            }
        }
    }
    
    func test_getLoans_failsOn200HTTPResponseWithInvalidJSON() async {
        let (sut, client) = makeSUT()
        let invalidJSON = Data("invalid json".utf8)
        client.stub(statusCode: 200, data: invalidJSON)
        
        do {
            _ = try await sut.getLoans()
            XCTFail("Expected failure on invalid JSON")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_getLoans_deliversNoLoansOn200HTTPResponseWithEmptyJSONList() async throws {
        let (sut, client) = makeSUT()
        client.stub(statusCode: 200, data: emptyListJSON())
        
        let loans = try await sut.getLoans()
        XCTAssertTrue(loans.isEmpty)
    }
    
    func test_getLoans_deliversLoansOn200HTTPResponseWithValidJSON() async throws {
        let (sut, client) = makeSUT()
        let loanJSON = makeLoanJSON(
            id: "123",
            amount: 5000.0,
            interestRate: 0.12,
            term: 120,
            purpose: "Business Expansion",
            riskRating: "A",
            borrower: [
                "id": "b-1",
                "name": "Jane Doe",
                "email": "jane@example.com",
                "creditScore": 720
            ],
            collateral: [
                "type": "Real Estate",
                "value": 15000.0
            ],
            documents: [
                ["type": "Income Statement", "url": "https://example.com/doc.pdf"]
            ],
            repaymentSchedule: [
                "installments": [
                    ["dueDate": "2026-09-15", "amountDue": 1250.0]
                ]
            ]
        )
        let payload = try JSONSerialization.data(withJSONObject: [loanJSON])
        client.stub(statusCode: 200, data: payload)
        
        let loans = try await sut.getLoans()
        
        XCTAssertEqual(loans.count, 1)
        let loan = loans[0]
        XCTAssertEqual(loan.id.value, "123")
        XCTAssertEqual(loan.amount.amount, 5000.0)
        XCTAssertEqual(loan.interestRate.value, 0.12)
        XCTAssertEqual(loan.term.days, 120)
        XCTAssertEqual(loan.purpose, .businessExpansion)
        XCTAssertEqual(loan.riskRating, .a)
        XCTAssertEqual(loan.borrower.id.value, "b-1")
        XCTAssertEqual(loan.borrower.name, "Jane Doe")
        XCTAssertEqual(loan.borrower.email, "jane@example.com")
        XCTAssertEqual(loan.borrower.creditScore, 720)
        XCTAssertEqual(loan.collateral.type, .realEstate)
        XCTAssertEqual(loan.collateral.value.amount, 15000.0)
        XCTAssertEqual(loan.documents.count, 1)
        XCTAssertEqual(loan.documents[0].type, .incomeStatement)
        XCTAssertEqual(loan.documents[0].url.absoluteString, "https://example.com/doc.pdf")
        XCTAssertEqual(loan.repaymentSchedule.installments.count, 1)
        XCTAssertEqual(loan.repaymentSchedule.installments[0].amountDue.amount, 1250.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        baseURL: URL = URL(string: "https://any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: CoreRepositoryImpl, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = CoreRepositoryImpl(client: client, baseURL: baseURL)
        return (sut, client)
    }
    
    private func emptyListJSON() -> Data {
        return Data("[]".utf8)
    }
    
    private func makeLoanJSON(
        id: String,
        amount: Double,
        interestRate: Double,
        term: Int,
        purpose: String,
        riskRating: String,
        borrower: [String: Any],
        collateral: [String: Any],
        documents: [[String: Any]],
        repaymentSchedule: [String: Any]
    ) -> [String: Any] {
        return [
            "id": id,
            "amount": amount,
            "interestRate": interestRate,
            "term": term,
            "purpose": purpose,
            "riskRating": riskRating,
            "borrower": borrower,
            "collateral": collateral,
            "documents": documents,
            "repaymentSchedule": repaymentSchedule
        ]
    }
    
    private final class HTTPClientSpy: HTTPClient, @unchecked Sendable {
        private struct Task: HTTPClientTask {
            func cancel() {}
        }
        
        private struct State {
            var requestedURLs: [URL] = []
            var completions: [@Sendable (HTTPClient.Result) -> Void] = []
            var stubbedResult: HTTPClient.Result?
        }
        
        private let state = OSAllocatedUnfairLock(initialState: State())
        
        var requestedURLs: [URL] {
            state.withLock { $0.requestedURLs }
        }
        
        func stub(with error: Error) {
            state.withLock {
                $0.stubbedResult = .failure(error)
            }
        }
        
        func stub(statusCode: Int, data: Data) {
            state.withLock {
                let response = HTTPURLResponse(
                    url: URL(string: "https://any-url.com")!,
                    statusCode: statusCode,
                    httpVersion: nil,
                    headerFields: nil
                )!
                $0.stubbedResult = .success((data, response))
            }
        }
        
        func get(
            from url: URL,
            headers: [String : String]?,
            completion: @escaping @Sendable (HTTPClient.Result) -> Void
        ) -> HTTPClientTask {
            state.withLock {
                $0.requestedURLs.append(url)
            }
            
            let result = state.withLock { $0.stubbedResult }
            if let result = result {
                switch result {
                case let .success((data, response)):
                    let urlSpecificResponse = HTTPURLResponse(
                        url: url,
                        statusCode: response.statusCode,
                        httpVersion: nil,
                        headerFields: nil
                    )!
                    completion(.success((data, urlSpecificResponse)))
                case let .failure(error):
                    completion(.failure(error))
                }
            } else {
                state.withLock {
                    $0.completions.append(completion)
                }
            }
            return Task()
        }
    }
}
