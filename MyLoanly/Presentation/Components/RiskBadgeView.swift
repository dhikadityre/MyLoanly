//
//  RiskBadgeView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import SwiftUI
import CoreDomain

struct RiskBadgeView: View {
    let rating: RiskRating
    
    var body: some View { render() }
    
    private func render() -> some View {
        Text("Risk \(rating.rawValue)")
            .font(.caption)
            .fontWeight(.bold)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.12))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}

private extension RiskBadgeView {
    private var color: Color {
        switch rating {
        case .a:
            return AppColors.green
        case .b:
            return AppColors.yellow
        case .c:
            return .red
        }
    }
}


