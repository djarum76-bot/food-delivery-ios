//
//  History.swift
//  FoodDelivery
//
//  Created by habil . on 12/01/24.
//

import Foundation

struct History: Identifiable, Codable {
    let id: Int
    let name: String
    let total, quantity: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, total, quantity
        case createdAt = "created_at"
    }
    
    static let example = History(id: 1, name: "Boba", total: 40000, quantity: 2, createdAt: "2024-01-12 21:49:11.100785+07:00")
}
