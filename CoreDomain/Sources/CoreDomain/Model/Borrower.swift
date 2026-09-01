//
//  Borrower.swift
//  CoreDomain
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation

public struct Borrower {
    public let id: BorrowerID
    public let name: String
    public let email: String
    public let creditScore: Int

    public init(
        id: BorrowerID,
        name: String,
        email: String,
        creditScore: Int
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.creditScore = creditScore
    }
}

public struct BorrowerID: Hashable {
    public let value: String

    public init(value: String) {
        self.value = value
    }
}
