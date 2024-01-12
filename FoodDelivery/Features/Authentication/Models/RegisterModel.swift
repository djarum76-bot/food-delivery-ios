//
//  RegisterModel.swift
//  FoodDelivery
//
//  Created by habil . on 09/01/24.
//

import Foundation

struct RegisterModel: Codable {
    let name, email, password: String

    enum CodingKeys: String, CodingKey {
        case name, email, password
    }
}
