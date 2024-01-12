//
//  Food.swift
//  FoodDelivery
//
//  Created by habil . on 11/01/24.
//

import Foundation

struct Food: Identifiable, Codable {
    let id: Int
    let name: String
    let price: Int
    let type: String
    
    static let example = Food(id: 2, name: "Veggie Tomato Mix", price: 20000, type: "Snacks")
}
