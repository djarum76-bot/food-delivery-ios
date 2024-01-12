//
//  LoginView.swift
//  FoodDelivery
//
//  Created by habil . on 06/01/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginVM = LoginViewModel()
    @EnvironmentObject private var rootVM: RootViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            AppTextField(label: "Email address", text: $loginVM.email)
            Spacer().frame(height: 40)
            AppTextField(label: "Password", text: $loginVM.password, isSecure: true)
            
            Spacer()
            AppButton(text: "Login", isDisabled: loginVM.isDisabled){
                Task{
                    let token = await loginVM.login()
                    
                    if token == "" {
                        loginVM.noTokenFound()
                        return
                    }
                    
                    withAnimation {
                        rootVM.root = .drawer
                        AuthService.shared.setToken(token: token)
                    }
                    
                    loginVM.reset()
                }
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 50)
        .alert("Oops...", isPresented: $loginVM.hasError) {} message: {
            Text(loginVM.loginError?.errorDescription ?? "You encountering an error")
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(RootViewModel())
}
