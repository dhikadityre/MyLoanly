//
//  AppLanguageManager.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import SwiftUI
import Combine

public enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case indonesian = "id"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .english:
            return "English"
        case .indonesian:
            return "Bahasa Indonesia"
        }
    }
    
    public var locale: Locale {
        Locale(identifier: rawValue)
    }
}

public final class AppLanguageManager: ObservableObject {
    public static let shared = AppLanguageManager()
    
    private let userDefaults: UserDefaults
    private let languageKey = "selected_app_language"
    
    @Published public var currentLanguage: AppLanguage {
        didSet {
            userDefaults.set(currentLanguage.rawValue, forKey: languageKey)
        }
    }
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        if let savedCode = userDefaults.string(forKey: languageKey),
           let language = AppLanguage(rawValue: savedCode) {
            self.currentLanguage = language
        } else {
            let preferred = Locale.preferredLanguages.first ?? "en"
            if preferred.starts(with: "id") {
                self.currentLanguage = .indonesian
            } else {
                self.currentLanguage = .english
            }
        }
    }
    
    public func setLanguage(_ language: AppLanguage) {
        self.currentLanguage = language
    }
}
