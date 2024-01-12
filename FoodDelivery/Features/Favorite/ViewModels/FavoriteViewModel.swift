//
//  FavoriteViewModel.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import SwiftUI

@MainActor
final class FavoriteViewModel: ObservableObject{
    @Published private(set) var networkingState = NetworkingState.initial
    @Published private(set) var favoriteError: FavoriteError?
    @Published var hasError = false
    @Published var foods: [Food] = []
    
    @Published private(set) var type = "All"
    let types = ["All","Foods", "Drinks", "Snacks", "Sauces", "Sweets", "Seafoods"]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    private let networkingManager: NetworkingManager!
    private var foodsResponse: Response<[Food]>?
    
    init(networkingManager: NetworkingManager = NetworkingManagerImpl.shared) {
        self.networkingManager = networkingManager
    }
    
    func changeType(type: String){
        self.type = type
    }
    
    func getAllFavoriteFood() async {
        networkingState = .loading
        
        do {
            foodsResponse = try await networkingManager.request(session: .shared, .getAllFavoriteFood(type: type), type: Response<[Food]>.self)
            foods = foodsResponse?.data ?? []
            
            networkingState = .success
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.favoriteError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.favoriteError = .system(error: error)
            }
        }
    }
}

extension FavoriteViewModel {
    enum FavoriteError: LocalizedError {
        case networking(error: LocalizedError)
        case system(error: Error)
    }
}

extension FavoriteViewModel.FavoriteError {
    var errorDescription: String? {
        switch self {
        case .networking(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}

extension FavoriteViewModel.FavoriteError: Equatable {
    static func == (lhs: FavoriteViewModel.FavoriteError, rhs: FavoriteViewModel.FavoriteError) -> Bool {
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
