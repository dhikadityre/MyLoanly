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
    
    public init(
        document: LoanDocument,
        docBaseURL: URL? = Config.docBaseUrl
    ) {
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
        } else if let docBaseURL {
            let baseURLString = docBaseURL.absoluteString.hasSuffix("/")
                ? String(docBaseURL.absoluteString.dropLast())
                : docBaseURL.absoluteString
            let path = document.url.path.hasPrefix("/")
                ? document.url.path
                : "/\(document.url.path)"
            self.resolvedURL = URL(string: baseURLString + path) ?? document.url
        } else {
            self.resolvedURL = document.url
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
