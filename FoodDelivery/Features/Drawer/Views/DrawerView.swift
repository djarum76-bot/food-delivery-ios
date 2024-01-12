//
//  DashboardView.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import SwiftUI

struct DrawerView: View {
    @StateObject private var drawerVM = DrawerViewModel()
    @EnvironmentObject private var rootVM: RootViewModel
    
    var body: some View {
        ZStack {
            Theme.primary
                .ignoresSafeArea()
            
            SideMenu()
                .environmentObject(drawerVM)
            
            ZStack{
                Color.white
                    .opacity(0.5)
                    .clipShape(.rect(cornerRadius: drawerVM.showMenu ? 15 : 0))
                    .shadow(color: .black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: drawerVM.showMenu ? -25 : 0)
                    .padding(.vertical, 30)
                
                Color.white
                    .opacity(0.4)
                    .clipShape(.rect(cornerRadius: drawerVM.showMenu ? 15 : 0))
                    .shadow(color: .black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: drawerVM.showMenu ? -50 : 0)
                    .padding(.vertical, 60)
                
                DashboardView()
                    .clipShape(.rect(cornerRadius: drawerVM.showMenu ? 15 : 0))
                    .allowsHitTesting(!drawerVM.showMenu)
            }
            .environmentObject(drawerVM)
            .scaleEffect(drawerVM.showMenu ? 0.84 : 1)
            .offset(x: drawerVM.showMenu ? getRect().width - 120 : 0)
            .ignoresSafeArea()
            .overlay(
                Button{
                    withAnimation(.spring){
                        drawerVM.showMenu.toggle()
                    }
                } label: {
                    VStack(spacing: 5){
                        Capsule()
                            .fill(drawerVM.showMenu ? .white : .primary)
                            .frame(width: 30, height: 3)
                            .rotationEffect(.init(degrees: drawerVM.showMenu ? -50 : 0))
                            .offset(x: drawerVM.showMenu ? 2 : 0, y: drawerVM.showMenu ? 9 : 0)
                        
                        VStack(alignment: .leading, spacing: 5){
                            Capsule()
                                .fill(drawerVM.showMenu ? .white : .primary)
                                .frame(width: 20, height: 3)
                            
                            Capsule()
                                .fill(drawerVM.showMenu ? .white : .primary)
                                .frame(width: 30, height: 3)
                                .offset(y: drawerVM.showMenu ? -8 : 0)
                        }
                        .rotationEffect(.init(degrees: drawerVM.showMenu ? 50 : 0))
                    }
                }.padding()
                , alignment: .topLeading
            )
        }
    }
}

#Preview {
    DrawerView()
        .environmentObject(DrawerViewModel())
        .environmentObject(RootViewModel())
}
