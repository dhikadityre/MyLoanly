//
//  LoanListScreenViewModel.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Combine
import Foundation
import CoreDomain

public final class LoanListScreenViewModel: ObservableObject {
    private let getLoansUseCase: GetLoansUseCase
    
    @Published public var state: LoanViewState = .idle
    @Published public var searchText: String = ""
    @Published public private(set) var loans: [Loan] = []
    @Published public private(set) var selectedRiskRating: String? = nil
    @Published public private(set) var selectedPurpose: String? = nil
    @Published public private(set) var sortBy: LoanSortOption = .default
    
    public let availableRiskRatings: [String] = [
        RiskRating.a.rawValue,
        RiskRating.b.rawValue,
        RiskRating.c.rawValue
    ]
    public let availableLoanPurposes: [String] = [
        LoanPurpose.businessExpansion.rawValue,
        LoanPurpose.education.rawValue,
        LoanPurpose.homeImprovement.rawValue,
        LoanPurpose.others.rawValue
    ]
    public let availableSortOptions: [LoanSortOption] = LoanSortOption.allCases
    
    public init(getLoansUseCase: GetLoansUseCase) {
        self.getLoansUseCase = getLoansUseCase
    }
    
    // MARK: - Computed Property
    
    public var rawFilteredLoans: [Loan] {
        var result = loans
        
        // Search Filter
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !query.isEmpty {
            result = result.filter { loan in
                loan.borrower.name.localizedCaseInsensitiveContains(query) ||
                loan.purpose.rawValue.localizedCaseInsensitiveContains(query)
            }
        }
        
        // Risk Rating Filter
        if let selectedRiskRating = selectedRiskRating {
            result = result.filter { $0.riskRating.rawValue == selectedRiskRating }
        }
        
        // Purpose Filter
        if let selectedPurpose = selectedPurpose {
            result = result.filter { $0.purpose.rawValue == selectedPurpose }
        }
        
        // Sorting
        switch sortBy {
        case .amountAscending:
            result.sort { $0.amount.amount < $1.amount.amount }
        case .amountDescending:
            result.sort { $0.amount.amount > $1.amount.amount }
        case .termAscending:
            result.sort { $0.term.days < $1.term.days }
        case .termDescending:
            result.sort { $0.term.days > $1.term.days }
        case .purpose:
            result.sort { $0.purpose.rawValue < $1.purpose.rawValue }
        case .`default`:
            break
        }
        
        return result
    }
    
    public var filteredLoans: [LoanItemDataView] {
        rawFilteredLoans.map { LoanItemDataView(loan: $0) }
    }
    
    public var isFilteredLoansEmpty: Bool {
        rawFilteredLoans.isEmpty
    }
    
    public var totalActiveLoanAmount: Decimal {
        rawFilteredLoans.reduce(0) { $0 + $1.amount.amount }
    }
    
    public var totalActiveLoanAmountFormatted: String {
        Money(amount: totalActiveLoanAmount).formatted
    }
    
    public var totalActiveLoanCount: Int {
        rawFilteredLoans.count
    }
    
    // MARK: - Action
    
    @MainActor
    public func fetchLoans() async {
        state = .loading
        do {
            let fetchedLoans = try await getLoansUseCase.execute()
            self.loans = fetchedLoans
            if fetchedLoans.isEmpty {
                state = .empty
            } else {
                state = .success
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    public func onAppear() async {
        if state == .idle {
            await fetchLoans()
        }
    }
    
    public func onRetry() async {
        await fetchLoans()
    }
    
    public func onClearSearchText() {
        searchText = ""
    }
    
    public func onResetFilters() {
        searchText = ""
        selectedRiskRating = nil
        selectedPurpose = nil
        sortBy = .default
    }
    
    // MARK: - (Risk) Filter Actions
    
    public func onSelectRiskRating(_ rating: String?) {
        selectedRiskRating = rating
    }
    
    public func onSelectRiskRating(_ rating: RiskRating?) {
        selectedRiskRating = rating?.rawValue
    }
    
    public func onTapAllRiskFilterThenSetToNil() {
        selectedRiskRating = nil
    }
    
    // MARK: - (Purpose) Filter Actions
    
    public func onSelectPurpose(_ purpose: String?) {
        selectedPurpose = purpose
    }
    
    public func onSelectPurpose(_ purpose: LoanPurpose?) {
        selectedPurpose = purpose?.rawValue
    }
    
    public func onTapAllPurposeFilterThenSetToNil() {
        selectedPurpose = nil
    }
    
    // MARK: - (Sort) Option Actions
    
    public func onSelectSortOption(_ option: LoanSortOption) {
        sortBy = option
    }
}
