//
//  Model.swift
//  Outcoding2
//
//  Created by Ignacio Arias on 2024-06-03.
//

import Foundation

struct Model: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    let appId: String
    let url: String
    let breeds: [ModelResults]
    
    enum CodingKeys: String, CodingKey {
        case appId = "id"
        case url
        case breeds
    }
}

struct ModelResults: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    let appId: String
    let name: String
    let description: String
    let origin: String
    let lifeSpan: String
    let affectionLevel: Int
    
    enum CodingKeys: String, CodingKey  {
        case appId = "id"
        case name
        case description
        case origin
        case lifeSpan = "life_span"
        case affectionLevel = "affection_level"
    }
}
