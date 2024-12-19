//
//  APIEndpoint.swift
//  spacex-launches
//
//  Created by oktay on 14.12.2024.
//

import Foundation

enum APIEndpoint {
    case getLaunches
    case getPastLaunches
    case getLauncDetail(id: String)

    var url: String {
        switch self {
        case .getLaunches:
            return "https://api.spacexdata.com/v5/launches/upcoming"
        case .getPastLaunches:
            return "https://api.spacexdata.com/v5/launches/past"
        case .getLauncDetail(let id):
            return "https://api.spacexdata.com/v5/launches/\(id)"
        }
    }
}

