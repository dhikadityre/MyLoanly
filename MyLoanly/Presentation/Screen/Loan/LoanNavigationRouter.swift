//
//  LoanNavigationRouter.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import SwiftUI
import Combine
import CoreDomain

extension Loan: @retroactive Hashable {
    public static func == (lhs: Loan, rhs: Loan) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public enum LoanDestination: Hashable {
    case details(Loan)
    case documents(Loan)
}

public final class LoanNavigationRouter: ObservableObject {
    @Published public var path = NavigationPath()
    
    public init() {}
    
    public func navigate(to destination: LoanDestination) {
        path.append(destination)
    }
    
    public func navigateBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    public func popToRoot() {
        path = NavigationPath()
    }
}
