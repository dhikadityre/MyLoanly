//
//  Config.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation

public protocol AppConfig {
    var apiBaseUrl: URL? { get }
    var docBaseUrl: URL? { get }
}

public struct DefaultAppConfig: AppConfig {
    public init() {}
    public var apiBaseUrl: URL? { Config.apiBaseUrl }
    public var docBaseUrl: URL? { Config.docBaseUrl }

}

public enum Config {
    private enum Keys: String {
        case apiBaseUrl = "API_BASE_URL"
        case docBaseUrl = "DOC_BASE_URL"
    }

    nonisolated(unsafe) private static let infoDictionary = Bundle.main.infoDictionary ?? [:]

    public static var apiBaseUrl: URL? {
        guard let value = stringValue(for: .apiBaseUrl) else {
            return nil
        }

        return URL(string: value)
    }
    
    public static var docBaseUrl: URL? {
        guard let value = stringValue(for: .docBaseUrl) else {
            return nil
        }

        return URL(string: value)
    }

    private static func stringValue(for key: Keys) -> String? {
        guard let value = infoDictionary[key.rawValue] as? String,
              !value.isEmpty else {
            return nil
        }

        return value
    }
}
