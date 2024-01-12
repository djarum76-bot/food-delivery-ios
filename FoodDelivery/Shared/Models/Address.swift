//
//  Address.swift
//  FoodDelivery
//
//  Created by habil . on 09/01/24.
//

import Foundation

struct Address: Codable{
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case address
    }
}
