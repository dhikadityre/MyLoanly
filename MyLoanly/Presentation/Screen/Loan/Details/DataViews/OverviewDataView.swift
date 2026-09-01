//
//  OverviewDataView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation
import CoreDomain

public struct OverviewDataView: Equatable {
    public let formattedAmount: String
    public let formattedInterestRate: String
    public let formattedTerm: String
    public let purpose: String
    public let riskRating: RiskRating
    
    public init(loan: Loan) {
        self.formattedAmount = loan.amount.formatted
        self.formattedInterestRate = loan.interestRate.formatted
        self.formattedTerm = loan.term.formattedMonths
        self.purpose = loan.purpose.rawValue
        self.riskRating = loan.riskRating
    }
    
    public init(
        formattedAmount: String,
        formattedInterestRate: String,
        formattedTerm: String,
        purpose: String,
        riskRating: RiskRating
    ) {
        self.formattedAmount = formattedAmount
        self.formattedInterestRate = formattedInterestRate
        self.formattedTerm = formattedTerm
        self.purpose = purpose
        self.riskRating = riskRating
    }
}
