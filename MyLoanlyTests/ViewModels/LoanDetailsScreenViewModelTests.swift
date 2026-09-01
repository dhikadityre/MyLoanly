//
//  LoanDetailsScreenViewModelTests.swift
//  MyLoanlyTests
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Testing
import Foundation
import CoreDomain
@testable import MyLoanly

@Suite("LoanDetailsScreenViewModel Tests")
struct LoanDetailsScreenViewModelTests {
    
    @Test("overviewDataView maps all loan overview fields correctly")
    func test_overviewDataView_mapping() {
        let loan = LoanMockFactory.makeLoan(
            amount: 7_500_000,
            interestRate: 0.15,
            termDays: 60,
            purpose: .education,
            riskRating: .b
        )
        let sut = LoanDetailsScreenViewModel(loan: loan)
        
        let overview = sut.overviewDataView
        #expect(overview.formattedAmount == loan.amount.formatted)
        #expect(overview.formattedInterestRate == loan.interestRate.formatted)
        #expect(overview.formattedTerm == loan.term.formattedMonths)
        #expect(overview.purpose == LoanPurpose.education.rawValue)
        #expect(overview.riskRating == .b)
    }
    
    @Test("borrowerDataView maps borrower fields correctly")
    func test_borrowerDataView_mapping() {
        let borrower = LoanMockFactory.makeBorrower(
            id: "borrower-99",
            name: "Jane Smith",
            email: "jane@example.com",
            creditScore: 820
        )
        let loan = LoanMockFactory.makeLoan(borrower: borrower)
        let sut = LoanDetailsScreenViewModel(loan: loan)
        
        let borrowerDataView = sut.borrowerDataView
        #expect(borrowerDataView.name == "Jane Smith")
        #expect(borrowerDataView.email == "jane@example.com")
        #expect(borrowerDataView.creditScore == 820)
        #expect(borrowerDataView.creditScoreTier == CreditScoreTier(score: 820).rawValue)
    }
    
    @Test("collateralDataView maps collateral fields correctly")
    func test_collateralDataView_mapping() {
        let collateral = LoanMockFactory.makeCollateral(
            type: .realEstate,
            amount: 25_000_000
        )
        let loan = LoanMockFactory.makeLoan(collateral: collateral)
        let sut = LoanDetailsScreenViewModel(loan: loan)
        
        let collateralDataView = sut.collateralDataView
        #expect(collateralDataView.type == CollateralType.realEstate.rawValue)
        #expect(collateralDataView.formattedValue == collateral.value.formatted)
    }
    
    @Test("repaymentDataView maps installments correctly")
    func test_repaymentDataView_mapping() {
        let installments = [
            Installment(dueDate: Date(), amountDue: Money(amount: 1_000_000)),
            Installment(dueDate: Date().addingTimeInterval(86400 * 30), amountDue: Money(amount: 1_000_000))
        ]
        let loan = LoanMockFactory.makeLoan(installments: installments)
        let sut = LoanDetailsScreenViewModel(loan: loan)
        
        let repaymentDataView = sut.repaymentDataView
        #expect(repaymentDataView.installments.count == 2)
        #expect(repaymentDataView.isEmpty == false)
    }
    
    @Test("repaymentDataView when installments is empty returns isEmpty true")
    func test_repaymentDataView_whenEmpty() {
        let loan = LoanMockFactory.makeLoan(installments: [])
        let sut = LoanDetailsScreenViewModel(loan: loan)
        
        let repaymentDataView = sut.repaymentDataView
        #expect(repaymentDataView.installments.isEmpty == true)
        #expect(repaymentDataView.isEmpty == true)
    }
    
    @Test("documentsDataView maps documents and formattedCount correctly")
    func test_documentsDataView_mapping() {
        let documents = [
            LoanMockFactory.makeDocument(type: .incomeStatement, url: URL(string: "https://example.com/doc1.pdf")!),
            LoanMockFactory.makeDocument(type: .unknown, url: URL(string: "https://example.com/doc2.pdf")!)
        ]
        let loan = LoanMockFactory.makeLoan(documents: documents)
        let sut = LoanDetailsScreenViewModel(loan: loan)
        
        let documentsDataView = sut.documentsDataView
        #expect(documentsDataView.documents.count == 2)
        #expect(documentsDataView.isEmpty == false)
        #expect(documentsDataView.formattedCount == "2 files")
    }
    
    @Test("documentsDataView formattedCount with single file uses singular form")
    func test_documentsDataView_singleFile() {
        let documents = [LoanMockFactory.makeDocument()]
        let loan = LoanMockFactory.makeLoan(documents: documents)
        let sut = LoanDetailsScreenViewModel(loan: loan)
        
        let documentsDataView = sut.documentsDataView
        #expect(documentsDataView.formattedCount == "1 file")
    }
}
