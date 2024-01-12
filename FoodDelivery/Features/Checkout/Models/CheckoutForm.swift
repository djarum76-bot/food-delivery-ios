//
//  CheckoutForm.swift
//  FoodDelivery
//
//  Created by habil . on 12/01/24.
//

import Foundation

struct CheckoutForm: Codable{
    let orderID: Int
    let foodID: Int
    let total: Int
    let quantity: Int
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case foodID = "food_id"
        case total, quantity
    }
}
