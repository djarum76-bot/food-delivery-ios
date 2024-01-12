//
//  Response.swift
//  FoodDelivery
//
//  Created by habil . on 09/01/24.
//

import Foundation

struct Response<T: Codable>: Codable {
    let status: Int
    let message: String
    let data: T
}
