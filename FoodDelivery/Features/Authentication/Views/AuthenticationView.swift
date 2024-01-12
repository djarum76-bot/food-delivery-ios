//
//  LoginView.swift
//  FoodDelivery
//
//  Created by habil . on 06/01/24.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject private var authenticationVM = AuthenticationViewModel()
    @EnvironmentObject private var rootVM: RootViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                TopSection(geometry: geometry)
                    .environmentObject(authenticationVM)
                
                BottomSection()
                    .environmentObject(authenticationVM)
            }
            .background(Theme.background)
        }
        .ignoresSafeArea()
    }
}

private struct TopSection: View {
    @EnvironmentObject private var authenticationVM: AuthenticationViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .clipShape(.rect(cornerRadius: 30))
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
            
            VStack(alignment: .leading){
                Spacer()
                Spacer()
                Spacer()
                
                HStack{
                    Spacer()
                    Image(decorative: "logo-big")
                    Spacer()
                }
                
                Spacer()
                
                Rectangle()
                    .frame(width: 125, height: 4)
                    .foregroundColor(Theme.primary)
                    .clipShape(.capsule)
                    .offset(x: authenticationVM.xOffset, y: 61)
                    .animation(.easeIn(duration: 0.5), value: authenticationVM.xOffset)
                
                HStack{
                    Spacer()
                    Button{
                        withAnimation{
                            authenticationVM.changeTab()
                        }
                    } label: {
                        Text("Login")
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                            .padding()
                    }
                    Spacer()
                    Button{
                        withAnimation{
                            authenticationVM.changeTab()
                        }
                    } label: {
                        Text("Register")
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                            .padding()
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: geometry.size.height * 0.4)
    }
}

private struct BottomSection: View {
    @EnvironmentObject private var authenticationVM: AuthenticationViewModel
    @EnvironmentObject private var rootVM: RootViewModel
    
    var body: some View {
        VStack {
            TabView(selection: $authenticationVM.selection){
                LoginView()
                    .transition(.slide)
                    .tag(TabAuthenticationState.login)
                
                RegisterView()
                    .transition(.slide)
                    .tag(TabAuthenticationState.register)
            }
            .environmentObject(rootVM)
            .gesture(
                DragGesture()
                    .onChanged{ value in
                        authenticationVM.height = value.translation.height
                        
                        if authenticationVM.height != .zero {
                            return
                        }
                        
                        authenticationVM.dragPage()
                    }
            )
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .frame(minHeight: 0, maxHeight: .infinity)
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(RootViewModel())
}
