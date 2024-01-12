//
//  AuthenticationViewModel.swift
//  FoodDelivery
//
//  Created by habil . on 06/01/24.
//

import Foundation

enum TabAuthenticationState: Hashable{
    case login, register
}

@MainActor
final class AuthenticationViewModel: ObservableObject{
    @Published var selection: TabAuthenticationState = .login
    @Published private(set) var xOffset: CGFloat = 48
    @Published var height: CGFloat = .zero
    
    func changeTab() {
        if selection == .login {
            selection = .register
            xOffset = 208
        } else {
            selection = .login
            xOffset = 48
        }
    }
    
    func dragPage() {
        if selection == .login {
            xOffset = 208
        } else {
            xOffset = 48
        }
    }
}
