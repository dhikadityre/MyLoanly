//
//  Loan.swift
//  CoreDomain
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation

public struct Loan: Identifiable {
    public let id: LoanID
    public let amount: Money
    public let interestRate: Percentage
    public let term: LoanTerm
    public let purpose: LoanPurpose
    public let riskRating: RiskRating
    public let borrower: Borrower
    public let collateral: Collateral
    public let documents: [LoanDocument]
    public let repaymentSchedule: RepaymentSchedule

    public init(
        id: LoanID,
        amount: Money,
        interestRate: Percentage,
        term: LoanTerm,
        purpose: LoanPurpose,
        riskRating: RiskRating,
        borrower: Borrower,
        collateral: Collateral,
        documents: [LoanDocument],
        repaymentSchedule: RepaymentSchedule
    ) {
        self.id = id
        self.amount = amount
        self.interestRate = interestRate
        self.term = term
        self.purpose = purpose
        self.riskRating = riskRating
        self.borrower = borrower
        self.collateral = collateral
        self.documents = documents
        self.repaymentSchedule = repaymentSchedule
    }
}

public struct LoanID: Hashable {
    public let value: String

    public init(value: String) {
        self.value = value
    }
}

public struct Percentage: Equatable {
    public let value: Decimal

    public init(value: Decimal) {
        self.value = value
    }
}

public extension Percentage {
    var formatted: String {
        value.toPercentage()
    }
}

public struct LoanTerm: Equatable {
    public let days: Int
    
    public init(days: Int) {
        self.days = days
    }
}

public extension LoanTerm {
    var formattedMonths: String {
        days.formattedMonths
    }
}

public enum LoanPurpose: String {
    case businessExpansion = "Business Expansion"
    case education = "Education"
    case homeImprovement = "Home Improvement"
    case others = "Others"
}

public enum RiskRating: String {
    case a = "A"
    case b = "B"
    case c = "C"
}
