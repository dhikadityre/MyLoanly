//
//  LoanDocument.swift
//  CoreDomain
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation

public struct LoanDocument {
    public let type: DocumentType
    public let url: URL

    public init(type: DocumentType, url: URL) {
        self.type = type
        self.url = url
    }
}

public enum DocumentType: String {
    case incomeStatement = "Income Statement"
    case unknown
}
