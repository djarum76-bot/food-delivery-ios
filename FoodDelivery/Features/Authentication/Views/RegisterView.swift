//
//  RegisterView.swift
//  FoodDelivery
//
//  Created by habil . on 06/01/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var registerVM = RegisterViewModel()
    @EnvironmentObject private var rootVM: RootViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            AppTextField(label: "Name", text: $registerVM.name)
            Spacer().frame(height: 40)
            AppTextField(label: "Email address", text: $registerVM.email)
            Spacer().frame(height: 40)
            AppTextField(label: "Password", text: $registerVM.password, isSecure: true)
            
            Spacer()
            AppButton(text: "Register", isDisabled: registerVM.isDisabled){
                Task{
                    let token = await registerVM.register()
                    
                    if token == "" {
                        registerVM.noTokenFound()
                        return
                    }
                    
                    withAnimation {
                        rootVM.root = .drawer
                        AuthService.shared.setToken(token: token)
                    }
                    
                    registerVM.reset()
                }
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 50)
        .alert("Oops...", isPresented: $registerVM.hasError) {} message: {
            Text(registerVM.registerError?.errorDescription ?? "You encountering an error")
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(RootViewModel())
}
