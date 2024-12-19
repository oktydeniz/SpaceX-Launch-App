//
//  Launchs.swift
//  spacex-launches
//
//  Created by oktay on 14.12.2024.
//

import Foundation

struct Launchs: Decodable, Identifiable {
    
    let links: Links?
    let flightNumber: Int?
    let name: String
    let dateLocal: String?
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case links
        case flightNumber = "flight_number"
        case name
        case dateLocal = "date_local"
        case id
    }
}
