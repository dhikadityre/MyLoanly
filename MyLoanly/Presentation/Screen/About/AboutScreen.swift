//
//  AboutScreen.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import SwiftUI

struct AboutScreen: View {
    @StateObject var viewModel: AboutScreenViewModel
    @ObservedObject var languageManager: AppLanguageManager
    
    init(
        viewModel: AboutScreenViewModel = AboutScreenViewModel(),
        languageManager: AppLanguageManager = .shared
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.languageManager = languageManager
    }
    
    var body: some View { render() }
    
    private func render() -> some View {
        ScrollView {
            VStack(spacing: 20) {
                renderAppHeaderCard()
                renderApplicationGroupBox()
                renderDeveloperGroupBox()
                renderSettingsGroupBox()
            }
            .padding()
        }
        .background(AppColors.canvas.ignoresSafeArea())
        .navigationTitle(Text(.About.about))
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension AboutScreen {
    private func renderAppHeaderCard() -> some View {
        VStack(spacing: 12) {
            Image(systemName: "dollarsign.bank.building.fill")
                .font(.system(size: 56))
                .foregroundColor(AppColors.navy)
                .padding(.bottom, 4)
            
            Text(viewModel.appName)
                .font(.title2.bold())
                .foregroundColor(AppColors.ink)
            
            Text(.About.manageAndTrackYourLoanApplicationsSeamlessly)
                .font(.subheadline)
                .foregroundColor(AppColors.muted)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(AppColors.surface)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
    
    private func renderApplicationGroupBox() -> some View {
        GroupBox(
            content: {
                ForEach(viewModel.applicationSettings) { item in
                    SettingsRowView(item: item)
                }
            },
            label: {
                SettingsLabelView(
                    labelResource: .About.application,
                    labelImage: ""
                )
            }
        )
        .groupBoxStyle(AppGroupBoxStyle())
    }
    
    private func renderDeveloperGroupBox() -> some View {
        GroupBox(
            content: {
                ForEach(viewModel.developerSettings) { item in
                    SettingsRowView(item: item)
                }
            },
            label: {
                SettingsLabelView(
                    labelResource: .About.developer,
                    labelImage: "person.crop.circle"
                )
            }
        )
        .groupBoxStyle(AppGroupBoxStyle())
    }
    
    private func renderSettingsGroupBox() -> some View {
        GroupBox(
            content: {
                VStack(spacing: 8) {
                    Divider()
                        .padding(.vertical, 4)
                    HStack {
                        Text(.About.language)
                            .font(.subheadline)
                            .foregroundColor(AppColors.muted)
                        Spacer()
                        Picker("", selection: $languageManager.currentLanguage) {
                            ForEach(AppLanguage.allCases) { language in
                                Text(language.displayName).tag(language)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(AppColors.navy)
                    }
                }
            },
            label: {
                SettingsLabelView(
                    labelResource: .About.settings,
                    labelImage: "gearshape"
                )
            }
        )
        .groupBoxStyle(AppGroupBoxStyle())
    }
}
