//
//  CreditScoreTier.swift
//  MyLoanly
//
//  Created by DHIKA ADITYA ARE on 01/09/26.
//

import Foundation

public enum CreditScoreTier: String {
    case excellent = "Excellent"
    case good = "Good"
    case fair = "Fair"
    
    public init(score: Int) {
        if score >= 750 {
            self = .excellent
        } else if score >= 650 {
            self = .good
        } else {
            self = .fair
        }
    }
    
    public static func getCreditScore(from score: Int) -> Self {
        CreditScoreTier(score: score)
    }
}
