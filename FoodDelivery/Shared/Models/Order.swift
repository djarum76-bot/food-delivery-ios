//
//  Order.swift
//  FoodDelivery
//
//  Created by habil . on 12/01/24.
//

import Foundation

struct Order: Identifiable, Codable, Equatable {
    let id, foodID, userID: Int
    let name: String
    let price: Int
    let type: String
    let quantity: Int

    enum CodingKeys: String, CodingKey {
        case id
        case foodID = "food_id"
        case userID = "user_id"
        case name, price, type, quantity
    }
    
    static let example = Order(id: 1, foodID: 1, userID: 1, name: "Veggie Tomato Mix", price: 20000, type: "Foods", quantity: 10)
}
