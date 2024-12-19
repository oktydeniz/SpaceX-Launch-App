//
//  Core.swift
//  spacex-launches
//
//  Created by oktay on 14.12.2024.
//

import Foundation

struct Core: Decodable {
    let landingAttempt: Bool?
    let landingSuccess: Bool?
    let landingType: String?

    enum CodingKeys: String, CodingKey {
        case landingAttempt = "landing_attempt"
        case landingSuccess = "landing_success"
        case landingType = "landing_type"
    }
}

