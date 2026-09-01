//
//  DocumentViewerSheet.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import SwiftUI

struct DocumentViewerSheet: View {
    let document: DocumentItemDataView
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            WebView(url: document.resolvedURL)
                .edgesIgnoringSafeArea(.bottom)
                .navigationTitle(Text(LocalizedStringKey(document.title), tableName: "LoanDocuments"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text(.LoanDocuments.close)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ShareLink(item: document.resolvedURL) {
                            Label {
                                Text(.LoanDocuments.share)
                            } icon: {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    }
                }
        }
    }
}

