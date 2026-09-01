//
//  DocumentType+Localization.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation
import CoreDomain

extension DocumentType {
    var localized: LocalizedStringResource {
        switch self {
        case .incomeStatement:
            return .LoanDocuments.incomeStatement
        case .unknown:
            return LocalizedStringResource("Unknown", table: "LoanDocuments")
        }
    }
}
