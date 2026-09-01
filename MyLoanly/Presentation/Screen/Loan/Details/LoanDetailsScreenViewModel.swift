//
//  LoanDetailsScreenViewModel.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Combine
import Foundation
import CoreDomain

public final class LoanDetailsScreenViewModel: ObservableObject {
    @Published public var loan: Loan
    
    public init(loan: Loan) {
        self.loan = loan
    }
    
    public var overviewDataView: OverviewDataView {
        OverviewDataView(
            loan: loan
        )
    }
    
    public var borrowerDataView: BorrowerDataView {
        BorrowerDataView(
            borrower: loan.borrower
        )
    }
    
    public var collateralDataView: CollateralDataView {
        CollateralDataView(
            collateral: loan.collateral
        )
    }
    
    public var repaymentDataView: RepaymentDataView {
        RepaymentDataView(
            repaymentSchedule: loan.repaymentSchedule
        )
    }
    
    public var documentsDataView: DocumentsDataView {
        DocumentsDataView(
            documents: loan.documents
        )
    }
}
