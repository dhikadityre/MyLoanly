//
//  FilterChipView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import SwiftUI

struct FilterChipView: View {
    let titleResource: LocalizedStringResource
    let isSelected: Bool
    let action: () -> Void
    
    init(title: String, isSelected: Bool, action: @escaping () -> Void) {
        self.titleResource = LocalizedStringResource(stringLiteral: title)
        self.isSelected = isSelected
        self.action = action
    }
    
    init(titleResource: LocalizedStringResource, isSelected: Bool, action: @escaping () -> Void) {
        self.titleResource = titleResource
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View { render() }
    
    private func render() -> some View {
        renderButton()
    }
}

extension FilterChipView {
    private func renderTitle() -> some View {
        Text(titleResource)
            .font(.subheadline)
            .fontWeight(isSelected ? .semibold : .regular)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(isSelected ? AppColors.navy : AppColors.surface)
            .foregroundColor(isSelected ? .white : AppColors.ink)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.clear : AppColors.muted.opacity(0.2), lineWidth: 1)
            )
            .cornerRadius(20)
    }
    
    private func renderButton() -> some View {
        Button(action: action) {
            renderTitle()
        }
    }
}

