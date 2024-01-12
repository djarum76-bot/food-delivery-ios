//
//  ProfileViewModel.swift
//  FoodDelivery
//
//  Created by habil . on 09/01/24.
//

import Foundation

@MainActor class ProfileViewModel: ObservableObject{
    @Published private(set) var networkingState = NetworkingState.initial
    @Published private(set) var profileError: ProfileError?
    @Published var hasError = false
    @Published var user: User?
    
    private let networkingManager: NetworkingManager!
    private var userResponse: Response<User>?
    
    init(networkingManager: NetworkingManager = NetworkingManagerImpl.shared) {
        self.networkingManager = networkingManager
    }
    
    var formattedAddress: String {
        if user == nil {
            return ""
        } else {
            return user!.address
        }
    }
    
    func getUser() async {
        networkingState = .loading
        
        do {
            userResponse = try await networkingManager.request(session: .shared, .getUser, type: Response<User>.self)
            user = userResponse?.data
            
            networkingState = .success
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.profileError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.profileError = .system(error: error)
            }
        }
    }
}

extension ProfileViewModel {
    enum ProfileError: LocalizedError {
        case networking(error: LocalizedError)
        case system(error: Error)
    }
}

extension ProfileViewModel.ProfileError {
    var errorDescription: String? {
        switch self {
        case .networking(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}

extension ProfileViewModel.ProfileError: Equatable {
    
    static func == (lhs: ProfileViewModel.ProfileError, rhs: ProfileViewModel.ProfileError) -> Bool {
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
