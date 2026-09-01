//
//  AboutSettingItemDataView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation

public struct AboutSettingItemDataView: Identifiable, Equatable {
    public let id: String
    public let keyResource: LocalizedStringResource?
    public let key: String
    public let value: String?
    public let linkTitle: String?
    public let linkContent: String?
    
    public init(
        keyResource: LocalizedStringResource,
        value: String? = nil,
        linkTitle: String? = nil,
        linkContent: String? = nil
    ) {
        self.id = keyResource.key
        self.keyResource = keyResource
        self.key = keyResource.key
        self.value = value
        self.linkTitle = linkTitle
        self.linkContent = linkContent
    }
    
    public init(
        key: String,
        value: String? = nil,
        linkTitle: String? = nil,
        linkContent: String? = nil
    ) {
        self.id = key
        self.keyResource = nil
        self.key = key
        self.value = value
        self.linkTitle = linkTitle
        self.linkContent = linkContent
    }
}
