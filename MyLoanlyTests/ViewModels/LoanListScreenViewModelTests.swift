//
//  LoanListScreenViewModelTests.swift
//  MyLoanlyTests
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Testing
import Foundation
import CoreDomain
@testable import MyLoanly

@Suite("LoanListScreenViewModel Tests")
@MainActor
struct LoanListScreenViewModelTests {
    
    // MARK: - Initial State
    
    @Test("Initial state should have default values and idle state")
    func test_initialState() {
        let spy = GetLoansUseCaseSpy()
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        #expect(sut.state == .idle)
        #expect(sut.searchText == "")
        #expect(sut.loans.isEmpty)
        #expect(sut.selectedRiskRating == nil)
        #expect(sut.selectedPurpose == nil)
        #expect(sut.sortBy == .default)
        #expect(sut.isFilteredLoansEmpty == true)
        #expect(sut.totalActiveLoanAmount == 0)
        #expect(sut.totalActiveLoanAmountFormatted == Money(amount: 0).formatted)
        #expect(sut.totalActiveLoanCount == 0)
        #expect(sut.availableRiskRatings == ["A", "B", "C"])
        #expect(sut.availableLoanPurposes == ["Business Expansion", "Education", "Home Improvement", "Others"])
        #expect(sut.availableSortOptions == LoanSortOption.allCases)
    }
    
    // MARK: - Data Fetching
    
    @Test("fetchLoans with non-empty loans updates state to success and populates loans")
    func test_fetchLoans_success_withNonEmptyLoans() async {
        let loans = [
            LoanMockFactory.makeLoan(id: "1", amount: 1_000_000),
            LoanMockFactory.makeLoan(id: "2", amount: 2_000_000)
        ]
        let spy = GetLoansUseCaseSpy(result: .success(loans))
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        await sut.fetchLoans()
        
        #expect(spy.executeCallCount == 1)
        #expect(sut.state == .success)
        #expect(sut.loans.count == 2)
        #expect(sut.filteredLoans.count == 2)
        #expect(sut.isFilteredLoansEmpty == false)
        #expect(sut.totalActiveLoanCount == 2)
        #expect(sut.totalActiveLoanAmount == 3_000_000)
        #expect(sut.totalActiveLoanAmountFormatted == Money(amount: 3_000_000).formatted)
    }
    
    @Test("fetchLoans with empty loans updates state to empty")
    func test_fetchLoans_success_withEmptyLoans() async {
        let spy = GetLoansUseCaseSpy(result: .success([]))
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        await sut.fetchLoans()
        
        #expect(spy.executeCallCount == 1)
        #expect(sut.state == .empty)
        #expect(sut.loans.isEmpty)
        #expect(sut.filteredLoans.isEmpty)
        #expect(sut.isFilteredLoansEmpty == true)
        #expect(sut.totalActiveLoanCount == 0)
        #expect(sut.totalActiveLoanAmount == 0)
    }
    
    @Test("fetchLoans when useCase fails updates state to error")
    func test_fetchLoans_failure() async {
        let expectedError = NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Server unavailable"])
        let spy = GetLoansUseCaseSpy(result: .failure(expectedError))
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        await sut.fetchLoans()
        
        #expect(spy.executeCallCount == 1)
        #expect(sut.state == .error("Server unavailable"))
        #expect(sut.loans.isEmpty)
        #expect(sut.filteredLoans.isEmpty)
    }
    
    // MARK: - Lifecycle Actions
    
    @Test("onAppear when state is idle triggers fetchLoans")
    func test_onAppear_whenIdle_fetchesLoans() async {
        let loans = [LoanMockFactory.makeLoan()]
        let spy = GetLoansUseCaseSpy(result: .success(loans))
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        #expect(sut.state == .idle)
        await sut.onAppear()
        
        #expect(spy.executeCallCount == 1)
        #expect(sut.state == .success)
    }
    
    @Test("onAppear when state is not idle does not trigger fetchLoans again")
    func test_onAppear_whenNotIdle_doesNotFetchLoans() async {
        let loans = [LoanMockFactory.makeLoan()]
        let spy = GetLoansUseCaseSpy(result: .success(loans))
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        await sut.fetchLoans()
        #expect(spy.executeCallCount == 1)
        
        await sut.onAppear()
        #expect(spy.executeCallCount == 1)
    }
    
    @Test("onRetry triggers fetchLoans")
    func test_onRetry_triggersFetchLoans() async {
        let loans = [LoanMockFactory.makeLoan()]
        let spy = GetLoansUseCaseSpy(result: .success(loans))
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        await sut.onRetry()
        #expect(spy.executeCallCount == 1)
        
        await sut.onRetry()
        #expect(spy.executeCallCount == 2)
    }
    
    // MARK: - Search Filtering
    
    @Test("Searching filters by borrower name case-insensitively and trims whitespace")
    func test_searchFilter_byBorrowerName() async {
        let loan1 = LoanMockFactory.makeLoan(id: "1", borrower: LoanMockFactory.makeBorrower(name: "Alice Smith"))
        let loan2 = LoanMockFactory.makeLoan(id: "2", borrower: LoanMockFactory.makeBorrower(name: "Bob Jones"))
        let loan3 = LoanMockFactory.makeLoan(id: "3", borrower: LoanMockFactory.makeBorrower(name: "Charlie Brown"))
        let spy = GetLoansUseCaseSpy(result: .success([loan1, loan2, loan3]))
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        await sut.fetchLoans()
        
        sut.searchText = "  alice  "
        #expect(sut.filteredLoans.count == 1)
        #expect(sut.filteredLoans.first?.borrowerName == "Alice Smith")
        
        sut.searchText = "JONES"
        #expect(sut.filteredLoans.count == 1)
        #expect(sut.filteredLoans.first?.borrowerName == "Bob Jones")
        
        sut.onClearSearchText()
        #expect(sut.searchText == "")
        #expect(sut.filteredLoans.count == 3)
    }
    
    @Test("Searching filters by loan purpose case-insensitively")
    func test_searchFilter_byPurpose() async {
        let loan1 = LoanMockFactory.makeLoan(id: "1", purpose: .businessExpansion)
        let loan2 = LoanMockFactory.makeLoan(id: "2", purpose: .education)
        let loan3 = LoanMockFactory.makeLoan(id: "3", purpose: .homeImprovement)
        let spy = GetLoansUseCaseSpy(result: .success([loan1, loan2, loan3]))
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        await sut.fetchLoans()
        
        sut.searchText = "education"
        #expect(sut.filteredLoans.count == 1)
        #expect(sut.filteredLoans.first?.purpose == LoanPurpose.education.rawValue)
        
        sut.searchText = "non-matching query"
        #expect(sut.filteredLoans.isEmpty)
        #expect(sut.isFilteredLoansEmpty == true)
    }
    
    // MARK: - Risk Rating Filtering
    
    @Test("Filtering by risk rating filters loans and resets properly")
    func test_riskRatingFilter() async {
        let loanA = LoanMockFactory.makeLoan(id: "1", riskRating: .a)
        let loanB = LoanMockFactory.makeLoan(id: "2", riskRating: .b)
        let loanC = LoanMockFactory.makeLoan(id: "3", riskRating: .c)
        let spy = GetLoansUseCaseSpy(result: .success([loanA, loanB, loanC]))
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        await sut.fetchLoans()
        
        sut.onSelectRiskRating(RiskRating.a)
        #expect(sut.selectedRiskRating == "A")
        #expect(sut.filteredLoans.count == 1)
        #expect(sut.filteredLoans.first?.riskRating == .a)
        
        sut.onSelectRiskRating("B")
        #expect(sut.selectedRiskRating == "B")
        #expect(sut.filteredLoans.count == 1)
        #expect(sut.filteredLoans.first?.riskRating == .b)
        
        sut.onTapAllRiskFilterThenSetToNil()
        #expect(sut.selectedRiskRating == nil)
        #expect(sut.filteredLoans.count == 3)
    }
    
    // MARK: - Purpose Filtering
    
    @Test("Filtering by purpose filters loans and resets properly")
    func test_purposeFilter() async {
        let loan1 = LoanMockFactory.makeLoan(id: "1", purpose: .businessExpansion)
        let loan2 = LoanMockFactory.makeLoan(id: "2", purpose: .education)
        let loan3 = LoanMockFactory.makeLoan(id: "3", purpose: .homeImprovement)
        let spy = GetLoansUseCaseSpy(result: .success([loan1, loan2, loan3]))
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        await sut.fetchLoans()
        
        sut.onSelectPurpose(LoanPurpose.education)
        #expect(sut.selectedPurpose == LoanPurpose.education.rawValue)
        #expect(sut.filteredLoans.count == 1)
        #expect(sut.filteredLoans.first?.purpose == LoanPurpose.education.rawValue)
        
        sut.onSelectPurpose(LoanPurpose.homeImprovement.rawValue)
        #expect(sut.selectedPurpose == LoanPurpose.homeImprovement.rawValue)
        #expect(sut.filteredLoans.count == 1)
        #expect(sut.filteredLoans.first?.purpose == LoanPurpose.homeImprovement.rawValue)
        
        sut.onTapAllPurposeFilterThenSetToNil()
        #expect(sut.selectedPurpose == nil)
        #expect(sut.filteredLoans.count == 3)
    }
    
    // MARK: - Sorting
    
    @Test("Sorting by amount ascending and descending")
    func test_sorting_byAmount() async {
        let lowAmountLoan = LoanMockFactory.makeLoan(id: "1", amount: 1_000_000)
        let midAmountLoan = LoanMockFactory.makeLoan(id: "2", amount: 5_000_000)
        let highAmountLoan = LoanMockFactory.makeLoan(id: "3", amount: 10_000_000)
        let spy = GetLoansUseCaseSpy(result: .success([midAmountLoan, highAmountLoan, lowAmountLoan]))
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        await sut.fetchLoans()
        
        sut.onSelectSortOption(.amountAscending)
        #expect(sut.sortBy == .amountAscending)
        #expect(sut.rawFilteredLoans.map(\.id.value) == ["1", "2", "3"])
        
        sut.onSelectSortOption(.amountDescending)
        #expect(sut.sortBy == .amountDescending)
        #expect(sut.rawFilteredLoans.map(\.id.value) == ["3", "2", "1"])
    }
    
    @Test("Sorting by term ascending and descending")
    func test_sorting_byTerm() async {
        let shortTermLoan = LoanMockFactory.makeLoan(id: "1", termDays: 30)
        let midTermLoan = LoanMockFactory.makeLoan(id: "2", termDays: 90)
        let longTermLoan = LoanMockFactory.makeLoan(id: "3", termDays: 180)
        let spy = GetLoansUseCaseSpy(result: .success([midTermLoan, longTermLoan, shortTermLoan]))
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        await sut.fetchLoans()
        
        sut.onSelectSortOption(.termAscending)
        #expect(sut.sortBy == .termAscending)
        #expect(sut.rawFilteredLoans.map(\.id.value) == ["1", "2", "3"])
        
        sut.onSelectSortOption(.termDescending)
        #expect(sut.sortBy == .termDescending)
        #expect(sut.rawFilteredLoans.map(\.id.value) == ["3", "2", "1"])
    }
    
    @Test("Sorting by purpose alphabetically")
    func test_sorting_byPurpose() async {
        let businessLoan = LoanMockFactory.makeLoan(id: "1", purpose: .businessExpansion)
        let educationLoan = LoanMockFactory.makeLoan(id: "2", purpose: .education)
        let othersLoan = LoanMockFactory.makeLoan(id: "3", purpose: .others)
        let spy = GetLoansUseCaseSpy(result: .success([othersLoan, educationLoan, businessLoan]))
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        await sut.fetchLoans()
        
        sut.onSelectSortOption(.purpose)
        #expect(sut.sortBy == .purpose)
        #expect(sut.rawFilteredLoans.map(\.id.value) == ["1", "2", "3"])
    }
    
    @Test("Sorting with default keeps original order")
    func test_sorting_default() async {
        let loan1 = LoanMockFactory.makeLoan(id: "1")
        let loan2 = LoanMockFactory.makeLoan(id: "2")
        let loan3 = LoanMockFactory.makeLoan(id: "3")
        let spy = GetLoansUseCaseSpy(result: .success([loan2, loan3, loan1]))
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        await sut.fetchLoans()
        
        sut.onSelectSortOption(.default)
        #expect(sut.rawFilteredLoans.map(\.id.value) == ["2", "3", "1"])
    }
    
    // MARK: - Combined Filters & Reset
    
    @Test("Combined filters apply together and onResetFilters clears everything")
    func test_combinedFiltersAndReset() async {
        let matchLoan = LoanMockFactory.makeLoan(
            id: "1",
            amount: 5_000_000,
            purpose: .businessExpansion,
            riskRating: .a,
            borrower: LoanMockFactory.makeBorrower(name: "John Miller")
        )
        let diffRatingLoan = LoanMockFactory.makeLoan(
            id: "2",
            amount: 10_000_000,
            purpose: .businessExpansion,
            riskRating: .b,
            borrower: LoanMockFactory.makeBorrower(name: "John Carter")
        )
        let diffPurposeLoan = LoanMockFactory.makeLoan(
            id: "3",
            amount: 3_000_000,
            purpose: .education,
            riskRating: .a,
            borrower: LoanMockFactory.makeBorrower(name: "John Davis")
        )
        let spy = GetLoansUseCaseSpy(result: .success([matchLoan, diffRatingLoan, diffPurposeLoan]))
        let sut = LoanListScreenViewModel(getLoansUseCase: spy)
        
        await sut.fetchLoans()
        
        sut.searchText = "John"
        sut.onSelectRiskRating(RiskRating.a)
        sut.onSelectPurpose(LoanPurpose.businessExpansion)
        sut.onSelectSortOption(.amountDescending)
        
        #expect(sut.filteredLoans.count == 1)
        #expect(sut.filteredLoans.first?.id == "1")
        #expect(sut.totalActiveLoanCount == 1)
        #expect(sut.totalActiveLoanAmount == 5_000_000)
        
        sut.onResetFilters()
        
        #expect(sut.searchText == "")
        #expect(sut.selectedRiskRating == nil)
        #expect(sut.selectedPurpose == nil)
        #expect(sut.sortBy == .default)
        #expect(sut.filteredLoans.count == 3)
    }
}
