//
//  SideMenu.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import SwiftUI

struct SideMenu: View {
    @EnvironmentObject private var drawerVM: DrawerViewModel
    @EnvironmentObject private var rootVM: RootViewModel
    @Namespace var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            Image("logo-big")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .clipShape(.rect(cornerRadius: 10))
                .background(.white)
                .clipShape(.rect(cornerRadius: 10))
                .padding(.top, 50)
            
            VStack(alignment: .leading, spacing: 10){
                TabButton(image: "house", title: "Home", tab: .home, selectedTab: $drawerVM.selectedTab, animation: animation)
                TabButton(image: "heart", title: "Favorite", tab: .favorite, selectedTab: $drawerVM.selectedTab, animation: animation)
                TabButton(image: "cart", title: "Order", tab: .order, selectedTab: $drawerVM.selectedTab, animation: animation)
                TabButton(image: "clock", title: "History", tab: .history, selectedTab: $drawerVM.selectedTab, animation: animation)
                TabButton(image: "person", title: "Profile", tab: .profile, selectedTab: $drawerVM.selectedTab, animation: animation)
            }
            .padding(.leading, -16)
            .padding(.top, 50)
            
            Spacer()
            
            LogoutButton()
                .environmentObject(drawerVM)
                .environmentObject(rootVM)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

#Preview {
    DrawerView()
        .environmentObject(DrawerViewModel())
        .environmentObject(RootViewModel())
}

