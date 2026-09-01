//
//  SettingsRowView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import SwiftUI

public struct SettingsRowView: View {
    public let key: String
    public let keyResource: LocalizedStringResource?
    public let value: String?
    public let valueLinkTitle: String?
    public let valueLinkContent: String?
    
    public init(
        keyResource: LocalizedStringResource,
        value: String? = nil,
        valueLinkTitle: String? = nil,
        valueLinkContent: String? = nil
    ) {
        self.key = keyResource.key
        self.keyResource = keyResource
        self.value = value
        self.valueLinkTitle = valueLinkTitle
        self.valueLinkContent = valueLinkContent
    }
    
    public init(
        key: String,
        value: String? = nil,
        valueLinkTitle: String? = nil,
        valueLinkContent: String? = nil
    ) {
        self.key = key
        self.keyResource = nil
        self.value = value
        self.valueLinkTitle = valueLinkTitle
        self.valueLinkContent = valueLinkContent
    }
    
    public init(item: AboutSettingItemDataView) {
        self.key = item.key
        self.keyResource = item.keyResource
        self.value = item.value
        self.valueLinkTitle = item.linkTitle
        self.valueLinkContent = item.linkContent
    }
    
    public var body: some View {
        VStack(spacing: 6) {
            Divider()
                .padding(.vertical, 4)
            HStack {
                if let keyResource {
                    Text(keyResource)
                        .font(.subheadline)
                        .foregroundColor(AppColors.muted)
                } else {
                    Text(key)
                        .font(.subheadline)
                        .foregroundColor(AppColors.muted)
                }
                Spacer()
                if let value, !value.isEmpty {
                    Text(value)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.ink)
                } else if let valueLinkTitle,
                          let valueLinkContent,
                          let url = destinationURL(from: valueLinkContent) {
                    HStack(spacing: 4) {
                        Link(valueLinkTitle, destination: url)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(AppColors.navy)
                        Image(systemName: "arrow.up.right.square")
                            .font(.caption)
                            .foregroundColor(AppColors.orange)
                    }
                } else {
                    EmptyView()
                }
            }
        }
    }
    
    private func destinationURL(from content: String) -> URL? {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        if trimmed.hasPrefix("http://") || trimmed.hasPrefix("https://") {
            return URL(string: trimmed)
        }
        return URL(string: "https://\(trimmed)")
    }
}
