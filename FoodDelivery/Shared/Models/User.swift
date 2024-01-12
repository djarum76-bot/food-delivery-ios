//
//  User.swift
//  FoodDelivery
//
//  Created by habil . on 09/01/24.
//

import Foundation

struct User: Codable {
    let id: Int
    let name, email, address: String
    
    static let example = User(id: 17, name: "hanabi", email: "hanabi@gmail.com", address: "Kuningan, Jakarta Selatan")
}
