//
//  LoanMapper.swift
//  PackageData
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation
import CoreDomain

extension BorrowerDTO {
    func toDomain() -> Borrower {
        Borrower(
            id: BorrowerID(value: id),
            name: name,
            email: email,
            creditScore: creditScore
        )
    }
}

extension CollateralDTO {
    func toDomain() -> Collateral {
        Collateral(
            type: CollateralType(rawValue: type) ?? .realEstate,
            value: Money(amount: Decimal(value))
        )
    }
}

extension LoanDocumentDTO {
    func toDomain() -> LoanDocument {
        LoanDocument(
            type: DocumentType(rawValue: type) ?? .unknown,
            url: URL(string: url) ?? URL(string: "about:blank")!
        )
    }
}

extension InstallmentDTO {
    func toDomain(dateFormatter: DateFormatter) -> Installment {
        Installment(
            dueDate: dateFormatter.date(from: dueDate) ?? Date(),
            amountDue: Money(amount: Decimal(amountDue))
        )
    }
}

extension RepaymentScheduleDTO {
    func toDomain(dateFormatter: DateFormatter) -> RepaymentSchedule {
        RepaymentSchedule(
            installments: installments.map { $0.toDomain(dateFormatter: dateFormatter) }
        )
    }
}

extension LoanDTO {
    func toDomain(dateFormatter: DateFormatter) -> Loan {
        Loan(
            id: LoanID(value: id),
            amount: Money(amount: Decimal(amount)),
            interestRate: Percentage(value: Decimal(interestRate)),
            term: LoanTerm(days: term),
            purpose: LoanPurpose(rawValue: purpose) ?? .others,
            riskRating: RiskRating(rawValue: riskRating) ?? .c,
            borrower: borrower.toDomain(),
            collateral: collateral.toDomain(),
            documents: documents.map { $0.toDomain() },
            repaymentSchedule: repaymentSchedule.toDomain(dateFormatter: dateFormatter)
        )
    }
}
