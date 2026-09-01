//
//  LoanDocumentsScreenViewModel.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Combine
import Foundation
import CoreDomain

public final class LoanDocumentsScreenViewModel: ObservableObject {
    @Published public var documents: [DocumentItemDataView]
    
    public var isEmpty: Bool { documents.isEmpty }
    
    public init(
        documents: [LoanDocument],
        docBaseURL: URL? = Config.docBaseUrl
    ) {
        self.documents = documents.map { DocumentItemDataView(document: $0, docBaseURL: docBaseURL) }
    }
    
    public init(documentDataViews: [DocumentItemDataView]) {
        self.documents = documentDataViews
    }
}

