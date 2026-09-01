//
//  InstallmentDTO.swift
//  PackageData
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation

struct InstallmentDTO: Decodable {
    let dueDate: String
    let amountDue: Double
}
