//
//  Model.swift
//  Outcoding2
//
//  Created by Ignacio Arias on 2024-06-03.
//

import Foundation

/*
 https://api.thecatapi.com/v1/images/search?api_key=live_TDxkreHiUYdSJTik1dbGMJe8ahwh8DAitDgQyQa0d4BsOfIOwfnLtm5KCJMCUpFE&limit=1&has_breeds=1
 */

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

    enum CodingKeys: String, CodingKey  {
        case appId = "id"
        case name
        case description
    }
}
