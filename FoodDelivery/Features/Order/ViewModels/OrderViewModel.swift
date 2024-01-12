//
//  OrderViewModel.swift
//  FoodDelivery
//
//  Created by habil . on 08/01/24.
//

import Foundation

@MainActor
final class OrderViewModel: ObservableObject{
    @Published private(set) var networkingState = NetworkingState.initial
    @Published private(set) var orderError: OrderError?
    @Published var hasError = false
    @Published var orders: [Order] = []
    
    private let networkingManager: NetworkingManager!
    private var ordersResponse: Response<[Order]>?
    
    init(networkingManager: NetworkingManager = NetworkingManagerImpl.shared) {
        self.networkingManager = networkingManager
    }
    
    func getAllOrder() async {
        networkingState = .loading
        
        do {
            ordersResponse = try await networkingManager.request(session: .shared, .getAllOrder, type: Response<[Order]>.self)
            orders = ordersResponse?.data ?? []
            
            networkingState = .success
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.orderError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.orderError = .system(error: error)
            }
        }
    }
    
    func removeFromLocalOrder(order: Order) {
        if let index = orders.firstIndex(of: order) {
            orders.remove(at: index)
        }
    }
    
    func removeFromGlobalOrder(order: Order) async {
        networkingState = .loading
        
        do {
            try await networkingManager.request(session: .shared, .removeFromOrder(id: order.id))
            networkingState = .success
            
            if let index = orders.firstIndex(of: order) {
                orders.remove(at: index)
            }
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.orderError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.orderError = .system(error: error)
            }
        }
    }    
    func updateUserAddress(id: Int, quantity: Int) async {
        networkingState = .loading
        
        do {
            let orderQuantityModel = OrderQuantity(id: id, quantity: quantity)
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(orderQuantityModel)
            
            try await networkingManager.request(session: .shared, .updateOrderQuantity(submissionData: data))
            networkingState = .success
            
            await getAllOrder()
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
            case is NetworkingManagerImpl.NetworkingError:
                self.orderError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.orderError = .system(error: error)
            }
        }
    }
}

extension OrderViewModel {
    enum OrderError: LocalizedError {
        case networking(error: LocalizedError)
        case system(error: Error)
    }
}

extension OrderViewModel.OrderError {
    var errorDescription: String? {
        switch self {
        case .networking(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}

extension OrderViewModel.OrderError: Equatable {
    static func == (lhs: OrderViewModel.OrderError, rhs: OrderViewModel.OrderError) -> Bool {
        switch (lhs, rhs) {
        case (.networking(let lhsType), .networking(let rhsType)):
            return lhsType.errorDescription == rhsType.errorDescription
        case (.system(let lhsType), .system(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
}
