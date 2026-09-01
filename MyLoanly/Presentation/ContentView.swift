//
//  ContentView.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import SwiftUI
import CoreDomain
import PackageData

enum AppTab: Hashable {
    case loans
    case about
}

struct ContentView: View {
    @ObservedObject private var languageManager: AppLanguageManager
    @State private var selectedTab: AppTab = .loans
    @StateObject private var router = LoanNavigationRouter()
    private let getLoansUseCase: GetLoansUseCase
    
    init(
        config: AppConfig = DefaultAppConfig(),
        languageManager: AppLanguageManager = .shared
    ) {
        let baseURL = config.apiBaseUrl ?? URL(string: "")!
        let repository = CoreRepositoryImpl(
            client: URLSessionHTTPClient(),
            baseURL: baseURL
        )
        self.getLoansUseCase = GetLoansUseCaseImpl(repository: repository)
        self.languageManager = languageManager
    }
    
    init(
        getLoansUseCase: GetLoansUseCase,
        languageManager: AppLanguageManager = .shared
    ) {
        self.getLoansUseCase = getLoansUseCase
        self.languageManager = languageManager
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            loansTabView
                .tabItem {
                    Label {
                        Text(.LoanList.loans)
                    } icon: {
                        Image(systemName: "list.bullet.rectangle.portrait")
                    }
                }
                .tag(AppTab.loans)
            
            aboutTabView
                .tabItem {
                    Label {
                        Text(.About.about)
                    } icon: {
                        Image(systemName: "person.crop.circle")
                    }
                }
                .tag(AppTab.about)
        }
        .tint(AppColors.navy)
        .environment(\.locale, languageManager.currentLanguage.locale)
    }
    
    private var loansTabView: some View {
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
                    .toolbar(.hidden, for: .tabBar)
                case .documents(let loan):
                    LoanDocumentsScreen(
                        viewModel: LoanDocumentsScreenViewModel(documents: loan.documents)
                    )
                    .toolbar(.hidden, for: .tabBar)
                }
            }
        }
        .environmentObject(router)
        .id(languageManager.currentLanguage)
    }
    
    private var aboutTabView: some View {
        NavigationStack {
            AboutScreen(languageManager: languageManager)
        }
        .id(languageManager.currentLanguage)
    }
}
