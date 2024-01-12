//
//  DashboardViewModel.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import SwiftUI

enum TabDrawerState{
    case home, favorite, order, history, profile
}

@MainActor
final class DrawerViewModel: ObservableObject{
    @Published var selectedTab: TabDrawerState = .home
    @Published var showMenu = false
}
