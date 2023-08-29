//
//  Episode.swift
//  RickandMortyWiki
//
//  Created by Omar Regalado on 28/08/23.
//

import Foundation


struct Episode: Codable, Identifiable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, airDate = "air_date", episode, characters, url, created
    }
}
