//
//  RepaymentSchedule.swift
//  CoreDomain
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation

public struct RepaymentSchedule {
    public let installments: [Installment]

    public init(installments: [Installment]) {
        self.installments = installments
    }
}

public struct Installment {
    public let dueDate: Date
    public let amountDue: Money

    public init(dueDate: Date, amountDue: Money) {
        self.dueDate = dueDate
        self.amountDue = amountDue
    }
}
