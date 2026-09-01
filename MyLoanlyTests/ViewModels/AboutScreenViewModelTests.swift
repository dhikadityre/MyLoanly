//
//  AboutScreenViewModelTests.swift
//  MyLoanlyTests
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Testing
import Foundation
@testable import MyLoanly

@Suite("AboutScreenViewModel Tests")
struct AboutScreenViewModelTests {
    
    @Test("Initializing with default values extracts bundle metadata and sets properties")
    func test_init_defaultValues() {
        let sut = AboutScreenViewModel()
        
        #expect(sut.appName == "MyLoanly")
        #expect(!sut.appVersion.isEmpty)
        #expect(!sut.appBuild.isEmpty)
        #expect(!sut.compatibility.isEmpty)
        #expect(!sut.swiftVersion.isEmpty)
        
        // Application settings
        #expect(sut.applicationSettings.count == 3)
        #expect(sut.applicationSettings[0].key == "Compatibility")
        #expect(sut.applicationSettings[0].keyResource == .About.compatibility)
        #expect(sut.applicationSettings[0].value == sut.compatibility)
        #expect(sut.applicationSettings[1].key == "Swift Version")
        #expect(sut.applicationSettings[1].keyResource == .About.swiftVersion)
        #expect(sut.applicationSettings[1].value == sut.swiftVersion)
        #expect(sut.applicationSettings[2].key == "Version")
        #expect(sut.applicationSettings[2].keyResource == .About.version)
        
        // Developer settings
        #expect(sut.developerSettings.count == 3)
        #expect(sut.developerSettings[0].key == "Developer")
        #expect(sut.developerSettings[0].keyResource == .About.developer)
        #expect(sut.developerSettings[0].value == "Dhika Aditya")
        #expect(sut.developerSettings[1].key == "Github")
        #expect(sut.developerSettings[1].linkTitle == "SwiftUI MasterClass")
        #expect(sut.developerSettings[1].linkContent == "swiftuimasterclass.com")
        #expect(sut.developerSettings[2].key == "Twitter")
        #expect(sut.developerSettings[2].linkTitle == "@google.com")
        #expect(sut.developerSettings[2].linkContent == "google.com")
    }
    
    @Test("Initializing with custom parameters sets compatibility and swift version")
    func test_init_customValues() {
        let sut = AboutScreenViewModel(
            appName: "CustomLoanApp",
            appVersion: "2.1.0",
            appBuild: "42",
            compatibility: "iOS 17.0",
            swiftVersion: "6.0"
        )
        
        #expect(sut.appName == "CustomLoanApp")
        #expect(sut.appVersion == "2.1.0")
        #expect(sut.appBuild == "42")
        #expect(sut.compatibility == "iOS 17.0")
        #expect(sut.swiftVersion == "6.0")
        #expect(sut.applicationSettings[0].value == "iOS 17.0")
        #expect(sut.applicationSettings[1].value == "6.0")
    }
    
    @Test("Initializing with custom settings arrays preserves custom items")
    func test_init_customSettingsArrays() {
        let customAppSettings = [
            AboutSettingItemDataView(key: "CustomKey", value: "CustomVal")
        ]
        let customDevSettings = [
            AboutSettingItemDataView(key: "CustomDev", value: "CustomDevVal")
        ]
        let sut = AboutScreenViewModel(
            applicationSettings: customAppSettings,
            developerSettings: customDevSettings
        )
        
        #expect(sut.applicationSettings.count == 1)
        #expect(sut.applicationSettings[0].key == "CustomKey")
        #expect(sut.developerSettings.count == 1)
        #expect(sut.developerSettings[0].key == "CustomDev")
    }
}
