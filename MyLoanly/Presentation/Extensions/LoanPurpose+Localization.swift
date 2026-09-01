//
//  LoanPurpose+Localization.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation
import CoreDomain

extension LoanPurpose {
    var localized: LocalizedStringResource {
        switch self {
        case .businessExpansion:
            return .LoanList.businessExpansion
        case .education:
            return .LoanList.education
        case .homeImprovement:
            return .LoanList.homeImprovement
        case .others:
            return .LoanList.others
        }
    }
}
