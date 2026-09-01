//
//  LoanDetailsScreen.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import SwiftUI
import CoreDomain

struct LoanDetailsScreen: View {
    @StateObject var viewModel: LoanDetailsScreenViewModel
    @EnvironmentObject var router: LoanNavigationRouter
    
    var body: some View { render() }
    
    private func render() -> some View {
        ScrollView {
            VStack(spacing: 20) {
                renderOverviewCard(data: viewModel.overviewDataView)
                renderBorrowerCardView(data: viewModel.borrowerDataView)
                renderCollateralCardView(data: viewModel.collateralDataView)
                renderRepaymentCardView(data: viewModel.repaymentDataView)
                renderDocumentsCardView(data: viewModel.documentsDataView)
            }
            .padding()
        }
        .background(AppColors.canvas)
        .navigationTitle(Text(.LoanDetails.loanDetails))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - Helpers
private extension LoanDetailsScreen {
    func creditScoreColor(for score: Int) -> Color {
        switch CreditScoreTier(score: score) {
        case .excellent:
            return AppColors.green
        case .good:
            return AppColors.yellow
        case .fair:
            return .red
        }
    }
}

// MARK: - General View
extension LoanDetailsScreen {
    private func renderSectionTitleGeneral(
        labelResource: LocalizedStringResource,
        systemImageName: String
    ) -> some View {
        Label {
            Text(labelResource)
        } icon: {
            Image(systemName: systemImageName)
        }
        .font(.headline)
        .foregroundColor(AppColors.navy)
    }
    
    private func renderKeyValueGeneral(
        keyResource: LocalizedStringResource,
        value: String
    ) -> some View {
        HStack {
            Text(keyResource)
                .foregroundColor(AppColors.muted)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.ink)
        }
    }
    
    private func renderKeyValueLocalized(
        keyResource: LocalizedStringResource,
        valueResource: LocalizedStringResource
    ) -> some View {
        HStack {
            Text(keyResource)
                .foregroundColor(AppColors.muted)
            Spacer()
            Text(valueResource)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.ink)
        }
    }
}

// MARK: - Header Overview Card
extension LoanDetailsScreen {
    private func renderLoanAmountAndRisk(overview: OverviewDataView) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(.LoanDetails.loanAmount)
                    .font(.caption)
                    .foregroundColor(AppColors.muted)
                    .textCase(.uppercase)
                Text(overview.formattedAmount)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.ink)
            }
            Spacer()
            RiskBadgeView(rating: overview.riskRating, resource: .LoanDetails.risk(overview.riskRating.rawValue))
        }
    }
    
    private func renderInterestRateAndTerm(overview: OverviewDataView) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(.LoanDetails.interestRate)
                    .font(.caption)
                    .foregroundColor(AppColors.muted)
                Text(overview.formattedInterestRate)
                    .font(.headline)
                    .foregroundColor(AppColors.ink)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(.LoanDetails.term)
                    .font(.caption)
                    .foregroundColor(AppColors.muted)
                Text(overview.formattedTerm)
                    .font(.headline)
                    .foregroundColor(AppColors.ink)
            }
        }
    }
    
    private func renderPurpose(overview: OverviewDataView) -> some View {
        HStack {
            Text(.LoanDetails.purpose)
                .font(.subheadline)
                .foregroundColor(AppColors.muted)
            Text(viewModel.loan.purpose.localized)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(AppColors.ink)
            Spacer()
        }
    }
    
    private func renderOverviewCard(data: OverviewDataView) -> some View {
        VStack(spacing: 16) {
            renderLoanAmountAndRisk(overview: data)
            Divider()
            renderInterestRateAndTerm(overview: data)
            renderPurpose(overview: data)
        }
        .cardStyle()
    }
}

// MARK: - Borrower Overview Card
extension LoanDetailsScreen {
    private func renderKeyValueEmail(email: String) -> some View {
        HStack {
            Text(.LoanDetails.email)
                .foregroundColor(AppColors.muted)
            Spacer()
            Text(email)
                .foregroundColor(AppColors.ink)
        }
    }
    
    private func renderPilTier(tier: CreditScoreTier, color: Color) -> some View {
        Text(tier.localized)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(color.opacity(0.12))
            .foregroundColor(color)
            .cornerRadius(6)
    }
    
    private func renderKeyValueCreditScore(score: Int) -> some View {
        let tier = CreditScoreTier(score: score)
        let color = creditScoreColor(for: score)
        return HStack {
            Text(.LoanDetails.creditScore)
                .foregroundColor(AppColors.muted)
            Spacer()
            HStack(spacing: 6) {
                Text("\(score)")
                    .fontWeight(.bold)
                    .foregroundColor(color)
                renderPilTier(tier: tier, color: color)
            }
        }
    }
    
    private func renderBorrowerInfo(data: BorrowerDataView) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            renderKeyValueGeneral(
                keyResource: .LoanDetails.name,
                value: data.name
            )
            renderKeyValueEmail(email: data.email)
            renderKeyValueCreditScore(score: data.creditScore)
        }
    }
    
    private func renderBorrowerCardView(data: BorrowerDataView) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            renderSectionTitleGeneral(
                labelResource: .LoanDetails.borrowerInformation,
                systemImageName: "person.crop.circle"
            )
            Divider()
            renderBorrowerInfo(data: data)
        }
        .cardStyle()
    }
}

// MARK: - Colateral Overview Card
extension LoanDetailsScreen {
    private func renderCollateralInfo(data: CollateralDataView) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            renderKeyValueLocalized(
                keyResource: .LoanDetails.collateralType,
                valueResource: .LoanDetails.realEstate
            )
            renderKeyValueGeneral(
                keyResource: .LoanDetails.estimatedValue,
                value: data.formattedValue
            )
        }
    }
    
    private func renderCollateralCardView(data: CollateralDataView) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            renderSectionTitleGeneral(
                labelResource: .LoanDetails.collateralDetails,
                systemImageName: "building.2"
            )
            Divider()
            renderCollateralInfo(data: data)
        }
        .cardStyle()
    }
}

// MARK: - Repayment Overview Card
extension LoanDetailsScreen {
    private func renderEmptyInstallmentState() -> some View {
        Text(.LoanDetails.noRepaymentInstallmentsScheduled)
            .foregroundColor(AppColors.muted)
            .font(.subheadline)
    }
    
    private func renderInstallmentAmountAndDueDate(
        amount: String,
        dueDate: String
    ) -> some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(amount)
                .fontWeight(.bold)
                .font(.subheadline)
                .foregroundColor(AppColors.ink)
            Text(.LoanDetails.due(dueDate))
                .font(.caption2)
                .foregroundColor(AppColors.muted)
        }
    }
    
    private func renderAvailableInstallmentState(installments: [InstallmentItemDataView]) -> some View {
        VStack(spacing: 8) {
            ForEach(installments) { item in
                HStack {
                    Text(.LoanDetails.installment(item.index + 1))
                        .font(.subheadline)
                        .foregroundColor(AppColors.ink)
                    Spacer()
                    renderInstallmentAmountAndDueDate(
                        amount: item.formattedAmount,
                        dueDate: item.formattedDueDate
                    )
                }
                .padding(.vertical, 6)
                if item.index < installments.count - 1 {
                    Divider()
                }
            }
        }
    }
    
    @ViewBuilder
    private func renderKeyValueInstallmentInfo(data: RepaymentDataView) -> some View {
        if data.isEmpty {
            renderEmptyInstallmentState()
        } else {
            renderAvailableInstallmentState(installments: data.installments)
        }
    }
    
    private func renderRepaymentCardView(data: RepaymentDataView) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            renderSectionTitleGeneral(
                labelResource: .LoanDetails.repaymentSchedule,
                systemImageName: "calendar.badge.clock"
            )
            Divider()
            renderKeyValueInstallmentInfo(data: data)
        }
        .cardStyle()
    }
}

// MARK: - Documents Overview Card
extension LoanDetailsScreen {
    private func renderEmptyDocumentState() -> some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: "doc.text.slash")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.muted)
                Text(.LoanDetails.noDocumentsAvailable)
                    .font(.subheadline)
                    .foregroundColor(AppColors.muted)
            }
            Spacer()
        }
        .padding(.vertical, 10)
    }
    
    private func renderAvailableDocumentState(data: DocumentsDataView) -> some View {
        Button(action: {
            router.navigate(to: .documents(viewModel.loan))
        }) {
            HStack {
                Text(.LoanDetails.viewLoanDocuments)
                    .fontWeight(.medium)
                Spacer()
                Text(data.formattedCount)
                    .font(.subheadline)
                    .foregroundColor(AppColors.muted)
                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.muted)
            }
            .padding()
            .background(AppColors.navy.opacity(0.08))
            .foregroundColor(AppColors.navy)
            .cornerRadius(10)
        }
    }
    
    @ViewBuilder
    private func renderDocumentState(data: DocumentsDataView) -> some View {
        if data.isEmpty {
            renderEmptyDocumentState()
        } else {
            renderAvailableDocumentState(data: data)
        }
    }
    
    private func renderDocumentsCardView(data: DocumentsDataView) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            renderSectionTitleGeneral(
                labelResource: .LoanDetails.documents,
                systemImageName: "doc.on.doc"
            )
            Divider()
            renderDocumentState(data: data)
        }
        .cardStyle()
    }
}
