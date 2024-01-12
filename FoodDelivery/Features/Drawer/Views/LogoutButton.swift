//
//  LogoutButton.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import SwiftUI

struct LogoutButton: View {
    @EnvironmentObject private var drawerVM: DrawerViewModel
    @EnvironmentObject private var rootVM: RootViewModel
    
    var body: some View {
        Button{
            withAnimation{
                drawerVM.showMenu.toggle()
                rootVM.root = .authentication
                AuthService.shared.removeToken()
            }
        } label: {
            HStack(spacing: 15) {
                Image(systemName: "rectangle.righthalf.inset.fill.arrow.right")
                    .font(.title2)
                    .frame(width: 30)
                
                Text("Log out")
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    LogoutButton()
        .environmentObject(DrawerViewModel())
        .environmentObject(RootViewModel())
}
