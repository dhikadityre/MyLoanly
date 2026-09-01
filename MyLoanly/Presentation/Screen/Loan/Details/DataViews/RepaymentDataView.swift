//
//  RepaymentDataView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation
import CoreDomain
public struct RepaymentDataView: Equatable {
    public let installments: [InstallmentItemDataView]
    public var isEmpty: Bool { installments.isEmpty }
    
    public init(repaymentSchedule: RepaymentSchedule) {
        self.installments = repaymentSchedule.installments.enumerated().map { index, installment in
            InstallmentItemDataView(index: index, installment: installment)
        }
    }
    
    public init(installments: [InstallmentItemDataView]) {
        self.installments = installments
    }
}
