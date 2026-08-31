//
//  LoanDTO.swift
//  PackageData
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation

struct LoanDTO: Decodable {
    let id: String
    let amount: Double
    let interestRate: Double
    let term: Int
    let purpose: String
    let riskRating: String
    let borrower: BorrowerDTO
    let collateral: CollateralDTO
    let documents: [LoanDocumentDTO]
    let repaymentSchedule: RepaymentScheduleDTO
}
