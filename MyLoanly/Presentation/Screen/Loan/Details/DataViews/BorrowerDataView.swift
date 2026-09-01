//
//  BorrowerDataView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation
import CoreDomain

public struct BorrowerDataView: Equatable {
    public let name: String
    public let email: String
    public let creditScore: Int
    
    public init(borrower: Borrower) {
        self.name = borrower.name
        self.email = borrower.email
        self.creditScore = borrower.creditScore
    }
    
    public init(name: String, email: String, creditScore: Int) {
        self.name = name
        self.email = email
        self.creditScore = creditScore
    }
    
    public var creditScoreTier: String {
        CreditScoreTier(score: creditScore).rawValue
    }
}
