//
//  DetailFood.swift
//  FoodDelivery
//
//  Created by habil . on 11/01/24.
//

import Foundation

struct Detail: Codable {
    let id: Int
    let name: String
    let price: Int
    let type: String
    let isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, price, type
        case isFavorite = "is_favorite"
    }
}
