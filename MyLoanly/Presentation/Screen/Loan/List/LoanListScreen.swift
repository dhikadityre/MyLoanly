//
//  LoanListScreen.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import SwiftUI
import CoreDomain

struct LoanListScreen: View {
    @StateObject var viewModel: LoanListScreenViewModel
    @EnvironmentObject var router: LoanNavigationRouter
    
    var body: some View { render() }
    
    private func render() -> some View {
        VStack(spacing: 0) {
            renderSearchAndFilterHeader()
            renderViewState()
        }
        .navigationTitle(Text(.LoanList.loans))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                renderToolbarMenu()
            }
        }
    }
}

// MARK: - Header
extension LoanListScreen {
    private func renderToolbarMenu() -> some View {
        Menu {
            ForEach(viewModel.availableSortOptions) { option in
                Button(action: {
                    viewModel.onSelectSortOption(option)
                }) {
                    HStack {
                        if viewModel.sortBy == option {
                            Image(systemName: "checkmark")
                        }
                        Text(option.localized)
                    }
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down.circle")
                .imageScale(.large)
                .foregroundColor(AppColors.navy)
        }
    }
    
    private func renderSearchBar() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.muted)
            TextField(String(localized: .LoanList.searchBorrowerOrPurpose), text: $viewModel.searchText)
                .foregroundColor(AppColors.ink)
                .autocorrectionDisabled()
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.onClearSearchText()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.muted)
                }
            }
        }
        .padding(10)
        .background(AppColors.canvas)
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func renderFilterRisk() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Text(.LoanList.filterRisk)
                    .font(.subheadline)
                    .foregroundColor(AppColors.muted)
                    .padding(.leading, 16)
                
                FilterChipView(
                    titleResource: .LoanList.all,
                    isSelected: viewModel.selectedRiskRating == nil,
                    action: { viewModel.onTapAllRiskFilterThenSetToNil() }
                )
                
                ForEach(viewModel.availableRiskRatings, id: \.self) { rating in
                    FilterChipView(
                        title: rating,
                        isSelected: viewModel.selectedRiskRating == rating,
                        action: { viewModel.onSelectRiskRating(rating) }
                    )
                }
            }
        }
    }
    
    private func renderFilterPurpose() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Text(.LoanList.filterPurpose)
                    .font(.subheadline)
                    .foregroundColor(AppColors.muted)
                    .padding(.leading, 16)
                
                FilterChipView(
                    titleResource: .LoanList.all,
                    isSelected: viewModel.selectedPurpose == nil,
                    action: { viewModel.onTapAllPurposeFilterThenSetToNil() }
                )
                
                ForEach(viewModel.availableLoanPurposes, id: \.self) { purpose in
                    FilterChipView(
                        titleResource: LoanPurpose(rawValue: purpose)?.localized ?? LocalizedStringResource(stringLiteral: purpose),
                        isSelected: viewModel.selectedPurpose == purpose,
                        action: { viewModel.onSelectPurpose(purpose) }
                    )
                }
            }
        }
        .padding(.bottom, 8)
    }
    
    private func renderSearchAndFilterHeader() -> some View {
        VStack(spacing: 12) {
            renderSearchBar()
            renderFilterRisk()
            renderFilterPurpose()
        }
        .padding(.top, 8)
        .background(AppColors.surface)
        .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 3)
    }
}

// MARK: - Content
extension LoanListScreen {
    private func renderTotalPriceActiveLoan() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(.LoanList.totalActiveLoans)
                .font(.caption)
                .foregroundColor(AppColors.muted)
                .textCase(.uppercase)
            Text(viewModel.totalActiveLoanAmountFormatted)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.ink)
        }
    }
    
    private func renderTotalActiveLoan() -> some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(.LoanList.count)
                .font(.caption)
                .foregroundColor(AppColors.muted)
                .textCase(.uppercase)
            Text("\(viewModel.totalActiveLoanCount)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.navy)
        }
    }
    
    private func renderSummaryCard() -> some View {
        VStack(spacing: 8) {
            HStack {
                renderTotalPriceActiveLoan()
                Spacer()
                renderTotalActiveLoan()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surface)
        )
        .padding(.horizontal)
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 5)
    }
    
    private func renderEmptyStateView() -> some View {
        VStack(spacing: 16) {
            Spacer(minLength: 50)
            Image(systemName: "tray")
                .font(.system(size: 64))
                .foregroundColor(AppColors.muted)
            Text(.LoanList.noLoansFound)
                .font(.headline)
                .foregroundColor(AppColors.ink)
            Text(.LoanList.weCouldntFindAnyLoansMatchingYourFiltersOrSearchCriteria)
                .font(.subheadline)
                .foregroundColor(AppColors.muted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button(action: {
                viewModel.onResetFilters()
            }) {
                Text(.LoanList.resetFilters)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppColors.navy)
            .controlSize(.regular)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func renderSuccessLoanListContent() -> some View {
        ScrollView {
            VStack(spacing: 16) {
                renderSummaryCard()
                
                if viewModel.isFilteredLoansEmpty {
                    renderEmptyStateView()
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredLoans) { loan in
                            LoanCardView(loan: loan) {
                                router.navigate(to: .details(loan.loan))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
    
    private func renderErrorStateView(message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.red)
            Text(.LoanList.failedToLoadLoans)
                .font(.headline)
                .foregroundColor(AppColors.ink)
            Text(message)
                .font(.subheadline)
                .foregroundColor(AppColors.muted)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button(action: {
                Task {
                    await viewModel.onRetry()
                }
            }) {
                Text(.LoanList.tryAgain)
            }
            .buttonStyle(.bordered)
            .tint(AppColors.navy)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func renderLoadingView() -> some View {
        VStack {
            Spacer()
            ProgressView {
                Text(.LoanList.loadingLoans)
            }
            .progressViewStyle(CircularProgressViewStyle())
            .tint(AppColors.navy)
            Spacer()
        }.frame(maxWidth: .infinity)
    }
    
    private func renderViewState() -> some View {
        Group {
            switch viewModel.state {
            case .idle:
                Color.clear
                    .onAppear {
                        Task {
                            await viewModel.onAppear()
                        }
                    }
            case .loading:
                renderLoadingView()
            case .success:
                renderSuccessLoanListContent()
            case .empty:
                renderEmptyStateView()
            case .error(let message):
                renderErrorStateView(message: message)
            }
        }
        .background(AppColors.canvas)
    }
}

