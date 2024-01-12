//
//  Endpoint.swift
//  FoodDelivery
//
//  Created by habil . on 09/01/24.
//

import Foundation

enum Endpoint {
    case register(submissionData: Data?)
    case login(submissionData: Data?)
    case getUser
    case getUserAddress
    case updateUserAddress(submissionData: Data?)
    case getAllFood(type: String)
    case getFood(id: Int)
    case addToFavorite(foodID: Int)
    case removeFromFavorite(foodID: Int)
    case getAllFavoriteFood(type: String)
    case getAllOrder
    case addToOrder(foodID: Int)
    case removeFromOrder(id: Int)
    case updateOrderQuantity(submissionData: Data?)
    case checkoutOrder(submissionData: Data?)
    case getAllHistory
}

extension Endpoint {
    enum MethodType: Equatable {
        case POST1(data: Data?)
        case POST2
        case GET
        case PUT(data: Data?)
        case DELETE
    }
}

extension Endpoint {
    
    var host: String { "192.168.100.177" }
    
    var path: String {
        switch self {
        case .register:
            return "/register"
        case .login:
            return "/login"
        case .getUser:
            return "/auth/user"
        case .getUserAddress, .updateUserAddress:
            return "/auth/user-address"
        case .getAllFood:
            return "/auth/foods"
        case .getFood(let id):
            return "/auth/food/\(id)"
        case .addToFavorite(let foodID), .removeFromFavorite(let foodID):
            return "/auth/favorite/\(foodID)"
        case .getAllFavoriteFood:
            return "/auth/favorites"
        case .getAllOrder:
            return "/auth/orders"
        case .addToOrder(let foodID):
            return "/auth/order/\(foodID)"
        case .removeFromOrder(let id):
            return "/auth/order/\(id)"
        case .updateOrderQuantity:
            return "/auth/order"
        case .checkoutOrder:
            return "/auth/checkout"
        case .getAllHistory:
            return "/auth/histories"
        }
    }
    
    var methodType: MethodType {
        switch self {
        case .register(let data), .login(let data), .checkoutOrder(let data):
            return .POST1(data: data)
        case .addToFavorite, .addToOrder:
            return .POST2
        case .getUser, .getUserAddress, .getAllFood, .getFood, .getAllFavoriteFood, .getAllOrder, .getAllHistory:
            return .GET
        case .updateUserAddress(let data), .updateOrderQuantity(let data):
            return .PUT(data: data)
        case .removeFromFavorite, .removeFromOrder:
            return .DELETE
        }
    }
    
    var queryItems: [String: String]? {
        switch self {
        case .getAllFood(let type), .getAllFavoriteFood(let type):
            if type == "All" {
                return nil
            } else {
                return ["type":"\(type)"]
            }
        default:
            return nil
        }
    }
}

extension Endpoint {
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = host
        urlComponents.port = 8090
        urlComponents.path = path
        
        var requestQueryItems = [URLQueryItem]()
        
        queryItems?.forEach { item in
            requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
        }
        
        urlComponents.queryItems = requestQueryItems
        
        return urlComponents.url
    }
}

extension URL {
    var isAuthorized: Bool {
        return self.absoluteString.contains("/auth/")
    }
}
