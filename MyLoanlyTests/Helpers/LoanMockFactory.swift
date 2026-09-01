//
//  LoanMockFactory.swift
//  MyLoanlyTests
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation
import CoreDomain
@testable import MyLoanly

enum LoanMockFactory {
    static func makeLoan(
        id: String = "loan-1",
        amount: Decimal = 5_000_000,
        interestRate: Decimal = 0.12,
        termDays: Int = 90,
        purpose: LoanPurpose = .businessExpansion,
        riskRating: RiskRating = .a,
        borrower: Borrower = makeBorrower(),
        collateral: Collateral = makeCollateral(),
        documents: [LoanDocument] = [makeDocument()],
        installments: [Installment] = []
    ) -> Loan {
        Loan(
            id: LoanID(value: id),
            amount: Money(amount: amount),
            interestRate: Percentage(value: interestRate),
            term: LoanTerm(days: termDays),
            purpose: purpose,
            riskRating: riskRating,
            borrower: borrower,
            collateral: collateral,
            documents: documents,
            repaymentSchedule: RepaymentSchedule(installments: installments)
        )
    }
    
    static func makeBorrower(
        id: String = "borrower-1",
        name: String = "John Doe",
        email: String = "john.doe@example.com",
        creditScore: Int = 750
    ) -> Borrower {
        Borrower(
            id: BorrowerID(value: id),
            name: name,
            email: email,
            creditScore: creditScore
        )
    }
    
    static func makeCollateral(
        type: CollateralType = .realEstate,
        amount: Decimal = 10_000_000
    ) -> Collateral {
        Collateral(
            type: type,
            value: Money(amount: amount)
        )
    }
    
    static func makeDocument(
        type: DocumentType = .incomeStatement,
        url: URL = URL(string: "https://example.com/docs/income.pdf")!
    ) -> LoanDocument {
        LoanDocument(
            type: type,
            url: url
        )
    }
}
