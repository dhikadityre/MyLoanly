//
//  CoreRepository.swift
//  CoreDomain
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation

public protocol CoreRepository {
    func getLoans() async throws -> [Loan]
}
