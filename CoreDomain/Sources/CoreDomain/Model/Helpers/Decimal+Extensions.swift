//
//  Decimal+Extensions.swift
//  CoreDomain
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation

public extension Decimal {
    /// Format Decimal to Currency string. Default is IDR / Rupiah.
    func toCurrency(
        currency: Currency = .idr,
        locale: Locale = Locale(identifier: "id_ID")
    ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency.rawValue
        formatter.locale = locale
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSDecimalNumber) ?? "\(currency.rawValue) \(self)"
    }
    
    /// Format Decimal to Rupiah (IDR) currency string.
    func toRupiah(locale: Locale = Locale(identifier: "id_ID")) -> String {
        return toCurrency(currency: .idr, locale: locale)
    }

    /// Format Decimal to Percentage string (e.g. 0.05 -> "5%").
    func toPercentage(
        locale: Locale = Locale(identifier: "id_ID"),
        minimumFractionDigits: Int = 0,
        maximumFractionDigits: Int = 2
    ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.locale = locale
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        return formatter.string(from: self as NSDecimalNumber) ?? "\(self * 100)%"
    }
}
