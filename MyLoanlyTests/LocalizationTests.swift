//
//  LocalizationTests.swift
//  MyLoanlyTests
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Testing
import Foundation

@Suite("Localization Tests")
struct LocalizationTests {
    
    private var enBundle: Bundle {
        Bundle.main.path(forResource: "en", ofType: "lproj").flatMap(Bundle.init(path:)) ?? .main
    }
    
    private var idBundle: Bundle {
        Bundle.main.path(forResource: "id", ofType: "lproj").flatMap(Bundle.init(path:)) ?? .main
    }
    
    private static let allTables = ["LoanList", "LoanDetails", "LoanDocuments"]
    private static let supportedLanguages = ["en", "id"]
    
    private func localizedKeys(inTable table: String, forLanguage language: String) -> [String: String] {
        guard let bundlePath = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: bundlePath),
              let stringsPath = bundle.path(forResource: table, ofType: "strings"),
              let dict = NSDictionary(contentsOfFile: stringsPath) as? [String: String] else {
            return [:]
        }
        return dict
    }
    
    @Test("Loop through all tables and verify no empty or missing translations",
          arguments: allTables, supportedLanguages)
    func test_allTables_haveCompleteTranslations(table: String, language: String) {
        let translations = localizedKeys(inTable: table, forLanguage: language)
        
        #expect(!translations.isEmpty, "Table '\(table)' for language '\(language)' should not be empty")
        
        for (key, value) in translations {
            #expect(!value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                    "Key '\(key)' in table '\(table)' (\(language)) has an empty translation")
        }
    }
    
    @Test("Loop through all tables and verify English and Indonesian have symmetric key sets",
          arguments: allTables)
    func test_keySymmetry_betweenLanguages(table: String) {
        let enKeys = Set(localizedKeys(inTable: table, forLanguage: "en").keys)
        let idKeys = Set(localizedKeys(inTable: table, forLanguage: "id").keys)
        
        let missingInId = enKeys.subtracting(idKeys)
        let missingInEn = idKeys.subtracting(enKeys)
        
        #expect(missingInId.isEmpty, "Keys in EN but missing in ID for table '\(table)': \(missingInId)")
        #expect(missingInEn.isEmpty, "Keys in ID but missing in EN for table '\(table)': \(missingInEn)")
    }
    
    // MARK: - Unsupported Locale Fallback
    
    @Test("Unsupported languages like Chinese fall back to development language (English)")
    func test_unsupportedLanguage_fallsBackToEnglish() {
        let preferred = Bundle.preferredLocalizations(
            from: ["en", "id"],
            forPreferences: ["zh-Hans-CN", "zh-Hans", "zh"]
        )
        #expect(preferred.first == "en")
    }
}
