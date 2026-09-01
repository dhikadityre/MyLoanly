//
//  DocumentItemDataView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation
import CoreDomain

public struct DocumentItemDataView: Identifiable, Equatable {
    public var id: String { url.absoluteString }
    public let title: String
    public let iconName: String
    public let url: URL
    public let resolvedURL: URL
    
    public init(document: LoanDocument) {
        self.title = document.type.rawValue
        self.url = document.url
        
        switch document.type {
        case .incomeStatement:
            self.iconName = "doc.text.fill"
        default:
            self.iconName = "doc.fill"
        }
        
        if document.url.scheme != nil {
            self.resolvedURL = document.url
        } else {
            let base = "https://raw.githubusercontent.com/andreascandle/p2p_json_test/main"
            self.resolvedURL = URL(string: base + document.url.path) ?? document.url
        }
    }
    
    public init(
        title: String,
        iconName: String,
        url: URL,
        resolvedURL: URL? = nil
    ) {
        self.title = title
        self.iconName = iconName
        self.url = url
        self.resolvedURL = resolvedURL ?? url
    }
}
