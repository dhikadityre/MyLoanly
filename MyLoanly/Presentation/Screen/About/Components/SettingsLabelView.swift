//
//  SettingsLabelView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import SwiftUI

public struct SettingsLabelView: View {
    public let labelResource: LocalizedStringResource?
    public let labelText: String
    public let labelImage: String
    
    public init(labelResource: LocalizedStringResource, labelImage: String) {
        self.labelResource = labelResource
        self.labelText = labelResource.key
        self.labelImage = labelImage
    }
    
    public init(labelText: String, labelImage: String) {
        self.labelResource = nil
        self.labelText = labelText
        self.labelImage = labelImage
    }
    
    public var body: some View {
        HStack {
            Image(systemName: labelImage)
                .font(.subheadline)
                .foregroundColor(AppColors.navy)
                .padding(
                    .trailing,
                    labelImage.isEmpty ? 0 : 2
                )
            if let labelResource {
                Text(labelResource)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .foregroundColor(AppColors.navy)
            } else {
                Text(labelText.uppercased())
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.navy)
            }
        }
    }
}
