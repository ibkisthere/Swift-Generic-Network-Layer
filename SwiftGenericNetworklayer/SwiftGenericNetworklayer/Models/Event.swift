//
//  Event.swift
//  SwiftGenericNetworklayer
//
//  Created by Ibukunoluwa Akintobi on 07/06/2024.
//

import Foundation

struct Event: Decodable {
    let id: String
    let name: String
    let date: String
    let location: String
    let description: String
    let attendees: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case date
        case location
        case description
        case attendees
    }
}
