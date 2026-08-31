//
//  RepaymentScheduleDTO.swift
//  PackageData
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation

struct RepaymentScheduleDTO: Decodable {
    let installments: [InstallmentDTO]
}
