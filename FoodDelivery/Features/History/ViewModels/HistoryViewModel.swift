//
//  HistoryViewModel.swift
//  FoodDelivery
//
//  Created by habil . on 08/01/24.
//

import Foundation

@MainActor
final class HistoryViewModel: ObservableObject{
    @Published private(set) var networkingState = NetworkingState.initial
    @Published private(set) var historyError: HistoryError?
    @Published var hasError = false
    @Published var histories: [History] = []
    
    private let networkingManager: NetworkingManager!
    private var historiesResponse: Response<[History]>?
    
    init(networkingManager: NetworkingManager = NetworkingManagerImpl.shared) {
        self.networkingManager = networkingManager
    }
    
    func getAllOrder() async {
        networkingState = .loading
        
        do {
            historiesResponse = try await networkingManager.request(session: .shared, .getAllHistory, type: Response<[History]>.self)
            histories = historiesResponse?.data ?? []
            
            networkingState = .success
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.historyError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.historyError = .system(error: error)
            }
        }
    }
}

extension HistoryViewModel {
    enum HistoryError: LocalizedError {
        case networking(error: LocalizedError)
        case system(error: Error)
    }
}

extension HistoryViewModel.HistoryError {
    var errorDescription: String? {
        switch self {
        case .networking(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}

extension HistoryViewModel.HistoryError: Equatable {
    static func == (lhs: HistoryViewModel.HistoryError, rhs: HistoryViewModel.HistoryError) -> Bool {
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
