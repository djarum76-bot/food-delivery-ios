//
//  FormValidator.swift
//  FoodDelivery
//
//  Created by habil . on 09/01/24.
//

import Foundation

protocol FormValidator {
    func validate(email: String, password: String) throws
    func validate(name: String, email: String, password: String) throws
}

struct FormValidatorImpl: FormValidator{
    static let shared: FormValidatorImpl = FormValidatorImpl()
    
    func validate(name: String, email: String, password: String) throws {
        if name.isEmpty {
            throw FormValidatorImplError.emptyName
        }
        
        if email.isEmpty {
            throw FormValidatorImplError.emptyEmail
        }
        
        if !email.isValidEmailFormat {
            throw FormValidatorImplError.invalidEmail
        }
        
        if password.isEmpty {
            throw FormValidatorImplError.emptyPassword
        }
        
        if password.count < 8 {
            throw FormValidatorImplError.invalidPassword
        }
    }
    
    func validate(email: String, password: String) throws {
        if email.isEmpty {
            throw FormValidatorImplError.emptyEmail
        }
        
        if !email.isValidEmailFormat {
            throw FormValidatorImplError.invalidEmail
        }
        
        if password.isEmpty {
            throw FormValidatorImplError.emptyPassword
        }
        
        if password.count < 8 {
            throw FormValidatorImplError.invalidPassword
        }
    }
}

extension FormValidatorImpl {
    enum FormValidatorImplError: LocalizedError {
        case emptyName
        
        case emptyEmail
        case invalidEmail
        
        case emptyPassword
        case invalidPassword
    }
}

extension FormValidatorImpl.FormValidatorImplError {
    
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Name can't be empty"
        case .emptyEmail:
            return "Email can't be empty"
        case .invalidEmail:
            return "Invalid email format"
        case .emptyPassword:
            return "Password can't be empty"
        case .invalidPassword:
            return "Password must be at least 8 characters long"
        }
    }
}

private extension String {
    var isValidEmailFormat: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}
