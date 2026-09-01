//
//  CollateralDataView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation
import CoreDomain

public struct CollateralDataView: Equatable {
    public let type: String
    public let formattedValue: String
    
    public init(collateral: Collateral) {
        self.type = collateral.type.rawValue
        self.formattedValue = collateral.value.formatted
    }
    
    public init(type: String, formattedValue: String) {
        self.type = type
        self.formattedValue = formattedValue
    }
}
