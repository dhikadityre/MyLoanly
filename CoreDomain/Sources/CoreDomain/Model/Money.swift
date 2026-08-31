//
//  Money.swift
//  CoreDomain
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation

public struct Money: Equatable {
    public let amount: Decimal
    public let currency: Currency

    public init(
        amount: Decimal,
        currency: Currency = .usd
    ) {
        self.amount = amount
        self.currency = currency
    }
}

public enum Currency: String {
    case usd = "USD"
}
