//
//  Links.swift
//  spacex-launches
//
//  Created by oktay on 14.12.2024.
//

import Foundation

struct Links: Decodable {
    let patch: Patch?
    let reddit: RedditLinks?
    let presskit: String?
    let webcast: String?
    let youtubeId: String?

    enum CodingKeys: String, CodingKey {
        case patch
        case reddit
        case presskit
        case webcast
        case youtubeId = "youtube_id"
    }
}
