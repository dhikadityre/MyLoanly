//
//  LoanDocumentsScreenViewModelTests.swift
//  MyLoanlyTests
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Testing
import Foundation
import CoreDomain
@testable import MyLoanly

@Suite("LoanDocumentsScreenViewModel Tests")
struct LoanDocumentsScreenViewModelTests {
    
    @Test("Initializing with empty LoanDocument array sets isEmpty to true")
    func test_init_withEmptyDocuments() {
        let sut = LoanDocumentsScreenViewModel(documents: [])
        
        #expect(sut.documents.isEmpty == true)
        #expect(sut.isEmpty == true)
    }
    
    @Test("Initializing with LoanDocument array maps to DocumentItemDataView correctly")
    func test_init_withLoanDocuments() {
        let docs = [
            LoanMockFactory.makeDocument(
                type: .incomeStatement,
                url: URL(string: "https://example.com/income.pdf")!
            ),
            LoanMockFactory.makeDocument(
                type: .unknown,
                url: URL(string: "https://example.com/other.pdf")!
            )
        ]
        let sut = LoanDocumentsScreenViewModel(documents: docs)
        
        #expect(sut.documents.count == 2)
        #expect(sut.isEmpty == false)
        #expect(sut.documents[0].title == DocumentType.incomeStatement.rawValue)
        #expect(sut.documents[0].iconName == "doc.text.fill")
        #expect(sut.documents[1].title == DocumentType.unknown.rawValue)
        #expect(sut.documents[1].iconName == "doc.fill")
    }
    
    @Test("Initializing with DocumentItemDataView array retains items")
    func test_init_withDocumentItemDataViews() {
        let dataViews = [
            DocumentItemDataView(
                title: "Custom Document",
                iconName: "doc.fill",
                url: URL(string: "https://example.com/custom.pdf")!
            )
        ]
        let sut = LoanDocumentsScreenViewModel(documentDataViews: dataViews)
        
        #expect(sut.documents.count == 1)
        #expect(sut.isEmpty == false)
        #expect(sut.documents.first?.title == "Custom Document")
    }
}
