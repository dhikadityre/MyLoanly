//
//  LoanItemDataView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation
import CoreDomain

public struct LoanItemDataView: Identifiable, Equatable {
    public let id: String
    public let borrowerName: String
    public let riskRating: RiskRating
    public let formattedAmount: String
    public let formattedTermAndRate: String
    public let purpose: String
    public let loan: Loan
    
    public init(loan: Loan) {
        self.id = loan.id.value
        self.borrowerName = loan.borrower.name
        self.riskRating = loan.riskRating
        self.formattedAmount = loan.amount.formatted
        self.formattedTermAndRate = "\(loan.term.formattedMonths) / \(loan.interestRate.formatted)"
        self.purpose = loan.purpose.rawValue
        self.loan = loan
    }
    
    public init(
        id: String,
        borrowerName: String,
        riskRating: RiskRating,
        formattedAmount: String,
        formattedTermAndRate: String,
        purpose: String,
        loan: Loan
    ) {
        self.id = id
        self.borrowerName = borrowerName
        self.riskRating = riskRating
        self.formattedAmount = formattedAmount
        self.formattedTermAndRate = formattedTermAndRate
        self.purpose = purpose
        self.loan = loan
    }
}
