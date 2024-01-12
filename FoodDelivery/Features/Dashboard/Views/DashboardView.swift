//
//  DashboardView.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var drawerVM: DrawerViewModel
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        TabView(selection: $drawerVM.selectedTab){
            HomeView()
                .transition(.slide)
                .environmentObject(drawerVM)
                .tag(TabDrawerState.home)
            
            FavoriteView()
                .transition(.slide)
                .environmentObject(drawerVM)
                .tag(TabDrawerState.favorite)
            
            OrderView()
                .transition(.slide)
                .environmentObject(drawerVM)
                .tag(TabDrawerState.order)
            
            HistoryView()
                .transition(.slide)
                .tag(TabDrawerState.history)
            
            ProfileView()
                .transition(.slide)
                .tag(TabDrawerState.profile)
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(DrawerViewModel())
}
