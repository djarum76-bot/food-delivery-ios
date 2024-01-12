//
//  RegisterViewModel.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import Foundation

@MainActor
final class RegisterViewModel: ObservableObject{
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    
    var isDisabled: Bool {
        name.isEmpty || email.isEmpty || password.isEmpty
    }
    
    var isLoading: Bool {
        networkingState == .loading
    }
    
    @Published private(set) var networkingState = NetworkingState.initial
    @Published private(set) var registerError: RegisterError?
    @Published var hasError = false
    
    private let networkingManager: NetworkingManager!
    private let formValidator: FormValidator!
    private var registerResponse: Response<Token>?
    
    init(networkingManager: NetworkingManager = NetworkingManagerImpl.shared, formValidator: FormValidator = FormValidatorImpl()) {
        self.networkingManager = networkingManager
        self.formValidator = formValidator
    }
    
    func register() async -> String {
        networkingState = .loading
        
        do {
            try formValidator.validate(email: email, password: password)
            let registerModel = RegisterModel(name: name, email: email, password: password)
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(registerModel)
            
            registerResponse = try await networkingManager.request(session: .shared, .register(submissionData: data), type: Response<Token>.self)
            networkingState = .success
            return registerResponse?.data.token ?? ""
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.registerError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            case is FormValidatorImpl.FormValidatorImplError:
                self.registerError = .validation(error: error as! FormValidatorImpl.FormValidatorImplError)
            default:
                self.registerError = .system(error: error)
            }
            
            return ""
        }
    }
    
    func noTokenFound() {
        hasError = true
        networkingState = .failed
    }
    
    func reset() {
        name = ""
        email = ""
        password = ""
        
        networkingState = NetworkingState.initial
        registerError = nil
        hasError = false
        
        registerResponse = nil
    }
}

extension RegisterViewModel {
    enum RegisterError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension RegisterViewModel.RegisterError {
    var errorDescription: String? {
        switch self {
        case .networking(let err), .validation(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}

extension RegisterViewModel.RegisterError: Equatable {
    static func == (lhs: RegisterViewModel.RegisterError, rhs: RegisterViewModel.RegisterError) -> Bool {
        switch (lhs, rhs) {
        case (.networking(let lhsType), .networking(let rhsType)):
            return lhsType.errorDescription == rhsType.errorDescription
        case (.validation(let lhsType), .validation(let rhsType)):
            return lhsType.errorDescription == rhsType.errorDescription
        case (.system(let lhsType), .system(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
}
