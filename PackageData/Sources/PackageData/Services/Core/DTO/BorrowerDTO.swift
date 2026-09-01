//
//  BorrowerDTO.swift
//  PackageData
//
//  Created by DHIKA ADITYA ARE on 31/08/26.
//

import Foundation

struct BorrowerDTO: Decodable {
    let id: String
    let name: String
    let email: String
    let creditScore: Int
}
