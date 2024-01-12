//
//  LoginModel.swift
//  FoodDelivery
//
//  Created by habil . on 09/01/24.
//

import Foundation

struct LoginModel: Codable {
    let email, password: String

    enum CodingKeys: String, CodingKey {
        case email, password
    }
}
