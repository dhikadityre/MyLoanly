//
//  LoanSortOption.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation

public enum LoanSortOption: String, CaseIterable, Identifiable {
    case `default` = "Default"
    case amountAscending = "Amount: Low to High"
    case amountDescending = "Amount: High to Low"
    case termAscending = "Term: Short to Long"
    case termDescending = "Term: Long to Short"
    case purpose = "Purpose"
    
    public var id: String { self.rawValue }
    
    public var localized: LocalizedStringResource {
        switch self {
        case .default:
            return .LoanList.default
        case .amountAscending:
            return .LoanList.amountLowToHigh
        case .amountDescending:
            return .LoanList.amountHighToLow
        case .termAscending:
            return .LoanList.termShortToLong
        case .termDescending:
            return .LoanList.termLongToShort
        case .purpose:
            return .LoanList.purpose
        }
    }
}
