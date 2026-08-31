//
//  Collateral.swift
//  CoreDomain
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation

public struct Collateral {
    public let type: CollateralType
    public let value: Money

    public init(type: CollateralType, value: Money) {
        self.type = type
        self.value = value
    }
}

public enum CollateralType: String {
    case realEstate = "Real Estate"
}
