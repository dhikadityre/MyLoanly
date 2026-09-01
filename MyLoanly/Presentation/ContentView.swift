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
    @StateObject private var router = LoanNavigationRouter()
    private let getLoansUseCase: GetLoansUseCase
    
    init(config: AppConfig = DefaultAppConfig()) {
        let baseURL = config.apiBaseUrl ?? URL(string: "")!
        let repository = CoreRepositoryImpl(
            client: URLSessionHTTPClient(),
            baseURL: baseURL
        )
        self.getLoansUseCase = GetLoansUseCaseImpl(repository: repository)
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            LoanListScreen(
                viewModel: LoanListScreenViewModel(getLoansUseCase: getLoansUseCase)
            )
            .navigationDestination(for: LoanDestination.self) { destination in
                switch destination {
                case .details(let loan):
                    LoanDetailsScreen(
                        viewModel: LoanDetailsScreenViewModel(loan: loan)
                    )
                case .documents(let loan):
                    LoanDocumentsScreen(
                        viewModel: LoanDocumentsScreenViewModel(documents: loan.documents)
                    )
                }
            }
        }
        .tint(AppColors.navy)
        .environmentObject(router)
    }
}
