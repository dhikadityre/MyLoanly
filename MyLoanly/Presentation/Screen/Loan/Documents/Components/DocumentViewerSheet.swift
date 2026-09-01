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
                .navigationTitle(document.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ShareLink(item: document.resolvedURL) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                }
        }
    }
}

