//
//  AppLanguageManagerTests.swift
//  MyLoanlyTests
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Testing
import Foundation
@testable import MyLoanly

@Suite("AppLanguageManager Tests")
struct AppLanguageManagerTests {
    
    private func makeSuiteUserDefaults() -> UserDefaults {
        let suiteName = "AppLanguageManagerTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
    
    @Test("AppLanguage properties map to correct identifiers and display names")
    func test_appLanguage_properties() {
        #expect(AppLanguage.english.rawValue == "en")
        #expect(AppLanguage.english.displayName == "English")
        #expect(AppLanguage.english.locale.identifier == "en")
        
        #expect(AppLanguage.indonesian.rawValue == "id")
        #expect(AppLanguage.indonesian.displayName == "Bahasa Indonesia")
        #expect(AppLanguage.indonesian.locale.identifier == "id")
    }
    
    @Test("Changing language updates currentLanguage and persists in UserDefaults")
    func test_setLanguage_persistsInUserDefaults() {
        let defaults = makeSuiteUserDefaults()
        let sut = AppLanguageManager(userDefaults: defaults)
        
        sut.setLanguage(.indonesian)
        #expect(sut.currentLanguage == .indonesian)
        #expect(defaults.string(forKey: "selected_app_language") == "id")
        
        sut.setLanguage(.english)
        #expect(sut.currentLanguage == .english)
        #expect(defaults.string(forKey: "selected_app_language") == "en")
    }
    
    @Test("Initializing with existing UserDefaults value restores saved language")
    func test_init_restoresSavedLanguage() {
        let defaults = makeSuiteUserDefaults()
        defaults.set("id", forKey: "selected_app_language")
        
        let sut = AppLanguageManager(userDefaults: defaults)
        #expect(sut.currentLanguage == .indonesian)
    }
}
