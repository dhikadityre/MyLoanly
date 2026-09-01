//
//  LoanDocumentsScreen.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import SwiftUI

struct LoanDocumentsScreen: View {
    @StateObject var viewModel: LoanDocumentsScreenViewModel
    @State private var selectedDocument: DocumentItemDataView? = nil
    
    var body: some View { render() }
    
    private func render() -> some View {
        Group {
            if viewModel.documents.isEmpty {
                renderEmptyDocumentsViewState()
            } else {
                renderSuccessDocumentListViewState()
            }
        }
        .navigationTitle("Loan Documents")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedDocument) { doc in
            DocumentViewerSheet(document: doc)
        }
    }
}

extension LoanDocumentsScreen {
    private func renderEmptyDocumentsViewState() -> some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.slash")
                .font(.system(size: 64))
                .foregroundColor(AppColors.muted)
            Text("No Documents Found")
                .font(.headline)
                .foregroundColor(AppColors.ink)
            Text("There are no documents uploaded for this loan.")
                .font(.subheadline)
                .foregroundColor(AppColors.muted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.canvas)
    }
    
    private func renderDocumentIcon(iconName: String) -> some View {
        Image(systemName: iconName)
            .font(.title2)
            .foregroundColor(AppColors.navy)
            .frame(width: 40, height: 40)
            .background(AppColors.navy.opacity(0.1))
            .cornerRadius(8)
    }
    
    private func renderDocumentInfo(title: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(AppColors.ink)
            Text("Tap to view document")
                .font(.caption)
                .foregroundColor(AppColors.muted)
        }
    }
    
    private func renderDocumentContainer(_ doc: DocumentItemDataView) -> some View {
        HStack(spacing: 16) {
            renderDocumentIcon(iconName: doc.iconName)
            renderDocumentInfo(title: doc.title)
            Spacer()
            Image(systemName: "eye")
                .foregroundColor(AppColors.muted)
        }
        .padding(.vertical, 4)
    }
    
    private func renderSuccessDocumentListViewState() -> some View {
        List(viewModel.documents) { doc in
            Button(action: {
                selectedDocument = doc
            }) {
                renderDocumentContainer(doc)
            }
            .buttonStyle(PlainButtonStyle())
            .listRowBackground(AppColors.surface)
        }
        .scrollContentBackground(.hidden)
        .background(AppColors.canvas)
    }
}

