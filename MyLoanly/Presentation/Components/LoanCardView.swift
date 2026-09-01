//
//  LoanCardView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import SwiftUI
import CoreDomain

struct LoanCardView: View {
    let loan: Loan
    let action: () -> Void
    
    var body: some View { render() }
    
    private func render() -> some View {
        Button(action: action) {
            renderContent()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension LoanCardView {
    private func renderBorrowersNameAndRiskBadge() -> some View {
        HStack {
            Text(loan.borrower.name)
                .font(.headline)
                .foregroundColor(AppColors.ink)
            Spacer()
            RiskBadgeView(rating: loan.riskRating)
        }
    }
    
    private func renderAmount() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Amount")
                .font(.caption)
                .foregroundColor(AppColors.muted)
            Text(loan.amount.formatted)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(AppColors.ink)
        }
    }
    
    private func renderTermRate() -> some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text("Term / Rate")
                .font(.caption)
                .foregroundColor(AppColors.muted)
            Text("\(loan.term.formattedMonths) / \(loan.interestRate.formatted)")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(AppColors.ink)
        }
    }
    
    private func renderCenterContentSection() -> some View {
        HStack(alignment: .bottom) {
            renderAmount()
            Spacer()
            renderTermRate()
        }
    }
    
    private func renderLoanPurposeTag() -> some View {
        Text(loan.purpose.rawValue)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(AppColors.canvas)
            .cornerRadius(6)
            .foregroundColor(AppColors.muted)
    }
    
    private func renderContent() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            renderBorrowersNameAndRiskBadge()
            Divider()
            renderCenterContentSection()
            renderLoanPurposeTag()
        }
        .padding()
        .background(AppColors.surface)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
    }
}

