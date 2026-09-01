//
//  Int+Extensions.swift
//  CoreDomain
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation

public extension Int {
    /// Format term days into month string (e.g. 30 -> "1 month", 60 -> "2 months").
    var formattedMonths: String {
        let months = Swift.max(1, self / 30)
        return "\(months) month\(months > 1 ? "s" : "")"
    }

    /// Format term days into month string.
    func toMonths() -> String {
        return formattedMonths
    }
}
