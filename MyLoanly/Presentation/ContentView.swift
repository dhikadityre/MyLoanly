//
//  ContentView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import SwiftUI
import CoreDomain
import PackageData

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            let repository = CoreRepositoryImpl(
                client: URLSessionHTTPClient(),
                baseURL: URL(string: "https://raw.githubusercontent.com")!
            )
            Task {
                do {
                    let loans = try await repository.getLoans()
                    print("Fetched loans count: \(loans.count)")
                } catch {
                    print("Error fetching loans: \(error)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
