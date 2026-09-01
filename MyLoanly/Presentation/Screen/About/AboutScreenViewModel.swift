//
//  AboutScreenViewModel.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Combine
import Foundation

public final class AboutScreenViewModel: ObservableObject {
    @Published public var appName: String
    @Published public var appVersion: String
    @Published public var appBuild: String
    @Published public var compatibility: String
    @Published public var swiftVersion: String
    @Published public var applicationSettings: [AboutSettingItemDataView]
    @Published public var developerSettings: [AboutSettingItemDataView]
    
    public init(
        bundle: Bundle = .main,
        appName: String? = nil,
        appVersion: String? = nil,
        appBuild: String? = nil,
        compatibility: String? = nil,
        swiftVersion: String? = nil,
        applicationSettings: [AboutSettingItemDataView]? = nil,
        developerSettings: [AboutSettingItemDataView]? = nil
    ) {
        let resolvedAppName = AboutScreenViewModel.resolveAppName(bundle: bundle, customValue: appName)
        let resolvedVersion = AboutScreenViewModel.resolveVersion(bundle: bundle, customValue: appVersion)
        let resolvedBuild = AboutScreenViewModel.resolveBuild(bundle: bundle, customValue: appBuild)
        let resolvedCompatibility = AboutScreenViewModel.resolveCompatibility(bundle: bundle, customValue: compatibility)
        let resolvedSwiftVersion = AboutScreenViewModel.resolveSwiftVersion(bundle: bundle, customValue: swiftVersion)
        
        self.appName = resolvedAppName
        self.appVersion = resolvedVersion
        self.appBuild = resolvedBuild
        self.compatibility = resolvedCompatibility
        self.swiftVersion = resolvedSwiftVersion
        
        self.applicationSettings = applicationSettings ?? AboutScreenViewModel.makeDefaultApplicationSettings(
            compatibility: resolvedCompatibility,
            swiftVersion: resolvedSwiftVersion,
            version: resolvedVersion,
            build: resolvedBuild
        )
        
        self.developerSettings = developerSettings ?? AboutScreenViewModel.makeDefaultDeveloperSettings()
    }
}

// MARK: - Resolvers & Factories
private extension AboutScreenViewModel {
    static func resolveAppName(bundle: Bundle, customValue: String?) -> String {
        customValue
            ?? bundle.infoDictionary?["CFBundleDisplayName"] as? String
            ?? "MyLoanly"
    }
    
    static func resolveVersion(bundle: Bundle, customValue: String?) -> String {
        customValue
            ?? bundle.infoDictionary?["CFBundleShortVersionString"] as? String
            ?? "1.0.0"
    }
    
    static func resolveBuild(bundle: Bundle, customValue: String?) -> String {
        customValue
            ?? bundle.infoDictionary?["CFBundleVersion"] as? String
            ?? "1"
    }
    
    static func resolveCompatibility(bundle: Bundle, customValue: String?) -> String {
        if let customValue { return customValue }
        let minOS = bundle.infoDictionary?["MinimumOSVersion"] as? String
            ?? bundle.object(forInfoDictionaryKey: "MinimumOSVersion") as? String
        return minOS != nil ? "iOS \(minOS!)" : "iOS 16+"
    }
    
    static func resolveSwiftVersion(bundle: Bundle, customValue: String?) -> String {
        if let customValue { return customValue }
        if let bundleSwift = bundle.infoDictionary?["SwiftVersion"] as? String
            ?? bundle.object(forInfoDictionaryKey: "SwiftVersion") as? String {
            return bundleSwift
        }
        #if swift(>=6.0)
        return "6.0"
        #elseif swift(>=5.9)
        return "5.9"
        #elseif swift(>=5.8)
        return "5.8"
        #else
        return "5.0"
        #endif
    }
    
    static func makeDefaultApplicationSettings(
        compatibility: String,
        swiftVersion: String,
        version: String,
        build: String
    ) -> [AboutSettingItemDataView] {
        [
            AboutSettingItemDataView(
                keyResource: .About.compatibility,
                value: compatibility
            ),
            AboutSettingItemDataView(
                keyResource: .About.swiftVersion,
                value: swiftVersion
            ),
            AboutSettingItemDataView(
                keyResource: .About.version,
                value: "v\(version) (\(build))"
            )
        ]
    }
    
    static func makeDefaultDeveloperSettings() -> [AboutSettingItemDataView] {
        [
            AboutSettingItemDataView(
                keyResource: .About.developer,
                value: "Dhika Aditya"
            ),
            AboutSettingItemDataView(
                key: "Github",
                linkTitle: "/github.com",
                linkContent: "https://github.com/dhikadityre"
            ),
            AboutSettingItemDataView(
                key: "LinkedIn",
                linkTitle: "/linkedin",
                linkContent: "www.linkedin.com/in/dhikadityre"
            )
        ]
    }
}
