//
//  Launch.swift
//  spacex-launches
//
//  Created by oktay on 14.12.2024.
//

import Foundation

struct Launch: Decodable, Identifiable {
    
    let links: Links?
    let flightNumber: Int?
    let name: String
    let dateLocal: String?
    let datePrecision: String?
    let upcoming: Bool?
    let cores: [Core]
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case links
        case flightNumber = "flight_number"
        case name
        case dateLocal = "date_local"
        case datePrecision = "date_precision"
        case upcoming
        case cores
        case id
    }
}
