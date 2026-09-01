//
//  View+CardStyle.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import SwiftUI

public struct CardModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .padding()
            .background(AppColors.surface)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}

public extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
}
