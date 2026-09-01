//
//  ModelExtensionsTests.swift
//  CoreDomainTests
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import XCTest
@testable import CoreDomain

final class ModelExtensionsTests: XCTestCase {
    
    // MARK: - Decimal+Extensions Tests
    
    func test_decimal_toCurrency_formatsIDRCorrectly() {
        let amount: Decimal = 1000000
        let formatted = amount.toCurrency(currency: .idr)
        
        XCTAssertTrue(formatted.contains("1.000.000") || formatted.contains("1,000,000") || formatted.contains("1000000"))
        XCTAssertTrue(formatted.contains("Rp") || formatted.contains("IDR"))
    }
    
    func test_decimal_toRupiah_formatsIDRCorrectly() {
        let amount: Decimal = 500000
        let formatted = amount.toRupiah()
        
        XCTAssertTrue(formatted.contains("500.000") || formatted.contains("500,000") || formatted.contains("500000"))
        XCTAssertTrue(formatted.contains("Rp") || formatted.contains("IDR"))
    }
    
    func test_decimal_toPercentage_formatsPercentCorrectly() {
        let rate: Decimal = 0.05
        let formatted = rate.toPercentage()
        
        XCTAssertTrue(formatted.contains("5%"))
    }
    
    // MARK: - Int+Extensions Tests
    
    func test_int_formattedMonths_formatsSingularAndPlural() {
        XCTAssertEqual(30.formattedMonths, "1 month")
        XCTAssertEqual(60.formattedMonths, "2 months")
        XCTAssertEqual(15.formattedMonths, "1 month")
        XCTAssertEqual(90.toMonths(), "3 months")
    }
    
    // MARK: - Money Tests
    
    func test_money_defaultCurrency_isIDR() {
        let money = Money(amount: 250000)
        
        XCTAssertEqual(money.currency, .idr)
        XCTAssertEqual(money.formatted, (250000 as Decimal).toCurrency(currency: .idr))
    }
    
    // MARK: - Percentage and LoanTerm Delegation Tests
    
    func test_percentage_delegatesToDecimalExtension() {
        let percentage = Percentage(value: 0.12)
        XCTAssertEqual(percentage.formatted, (0.12 as Decimal).toPercentage())
    }
    
    func test_loanTerm_delegatesToIntExtension() {
        let term = LoanTerm(days: 60)
        XCTAssertEqual(term.formattedMonths, 60.formattedMonths)
    }
}
