//
//  LoanViewState.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation

public enum LoanViewState: Equatable {
    case idle
    case loading
    case success
    case empty
    case error(String)
}
