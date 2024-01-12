//
//  RootView.swift
//  FoodDelivery
//
//  Created by habil . on 06/01/24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var rootVM = RootViewModel()
    
    var body: some View {
        switch rootVM.root {
        case .introduction:
            IntroductionView()
                .environmentObject(rootVM)
                .transition(.slide)
        default:
            if AuthService.shared.isAvailable {
                DrawerView()
                    .environmentObject(rootVM)
                    .transition(.slide)
            } else {
                AuthenticationView()
                    .environmentObject(rootVM)
                    .transition(.slide)
            }
//        case .authentication:
//            AuthenticationView()
//                .environmentObject(rootVM)
//                .transition(.slide)
//        case .drawer:
//            DrawerView()
//                .environmentObject(rootVM)
//                .transition(.slide)
        }
    }
}

#Preview {
    RootView()
}
