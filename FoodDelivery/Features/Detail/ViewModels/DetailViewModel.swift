//
//  DetailViewModel.swift
//  FoodDelivery
//
//  Created by habil . on 09/01/24.
//

import Foundation

@MainActor
final class DetailViewModel: ObservableObject{
    @Published private(set) var networkingState = NetworkingState.initial
    @Published private(set) var detailError: DetailError?
    @Published var hasError = false
    @Published var food: Detail?
    
    private let networkingManager: NetworkingManager!
    private var foodResponse: Response<Detail>?
    
    init(networkingManager: NetworkingManager = NetworkingManagerImpl.shared) {
        self.networkingManager = networkingManager
    }
    
    var isFavorite: Bool {
        return food?.isFavorite ?? false
    }
    
    func getFood(id: Int) async {
        networkingState = .loading
        
        do {
            foodResponse = try await networkingManager.request(session: .shared, .getFood(id: id), type: Response<Detail>.self)
            food = foodResponse?.data
            
            networkingState = .success
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.detailError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.detailError = .system(error: error)
            }
        }
    }
    
    func addToFavorite(foodID: Int) async {
        networkingState = .loading
        
        do {
            try await networkingManager.request(session: .shared, .addToFavorite(foodID: foodID))
            networkingState = .success
            
            await getFood(id: foodID)
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.detailError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.detailError = .system(error: error)
            }
        }
    }
    
    func removeFromFavorite(foodID: Int) async {
        networkingState = .loading
        
        do {
            try await networkingManager.request(session: .shared, .removeFromFavorite(foodID: foodID))
            networkingState = .success
            
            await getFood(id: foodID)
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.detailError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.detailError = .system(error: error)
            }
        }
    }
    
    func addToOrder(foodID: Int) async -> Bool {
        networkingState = .loading
        
        do {
            try await networkingManager.request(session: .shared, .addToOrder(foodID: foodID))
            networkingState = .success
            
            return true
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.detailError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.detailError = .system(error: error)
            }
            
            return false
        }
    }
}

extension DetailViewModel {
    enum DetailError: LocalizedError {
        case networking(error: LocalizedError)
        case system(error: Error)
    }
}

extension DetailViewModel.DetailError {
    var errorDescription: String? {
        switch self {
        case .networking(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}

extension DetailViewModel.DetailError: Equatable {
    static func == (lhs: DetailViewModel.DetailError, rhs: DetailViewModel.DetailError) -> Bool {
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
