//
//  InstallmentItemDataView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation
import CoreDomain

public struct InstallmentItemDataView: Identifiable, Equatable {
    public var id: Int { index }
    public let index: Int
    public let title: String
    public let formattedAmount: String
    public let formattedDueDate: String
    
    public init(index: Int, installment: Installment) {
        self.index = index
        self.title = "Installment #\(index + 1)"
        self.formattedAmount = installment.amountDue.formatted
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        self.formattedDueDate = formatter.string(from: installment.dueDate)
    }
    
    public init(
        index: Int,
        title: String,
        formattedAmount: String,
        formattedDueDate: String
    ) {
        self.index = index
        self.title = title
        self.formattedAmount = formattedAmount
        self.formattedDueDate = formattedDueDate
    }
}
