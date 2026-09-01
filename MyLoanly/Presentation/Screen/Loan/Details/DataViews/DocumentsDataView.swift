//
//  DocumentsDataView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation
import CoreDomain

public struct DocumentsDataView: Equatable {
    public let documents: [LoanDocument]
    public var isEmpty: Bool { documents.isEmpty }
    
    public var formattedCount: String {
        "\(documents.count) file\(documents.count == 1 ? "" : "s")"
    }
    
    public init(documents: [LoanDocument]) {
        self.documents = documents
    }
}
