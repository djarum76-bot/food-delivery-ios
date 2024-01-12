//
//  HomeView.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeVM = HomeViewModel()
    @EnvironmentObject private var drawerVM: DrawerViewModel
    @Namespace var animation
    
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(homeVM.types, id: \.self){ type in
                            FilterButton(isActive: homeVM.type == type, type: type, animation: animation) {
                                withAnimation{
                                    homeVM.changeType(type: type)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                
                Spacer().frame(height: 10)
                
                if homeVM.foods.isEmpty && homeVM.networkingState != .loading {
                    VStack(spacing: 10){
                        Spacer()
                        
                        Image(systemName: "fork.knife")
                            .font(.system(size: 150))
                            .foregroundStyle(.gray)
                        
                        Text("No food yet")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        
                        Spacer()
                    }
                } else {
                    ScrollView{
                        LazyVGrid(columns: homeVM.columns, spacing: 0){
                            ForEach(homeVM.foods){ food in
                                FoodItem(food: food)
                                    .environmentObject(drawerVM)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }
            .onChange(of: homeVM.type, { oldValue, newValue in
                Task {
                    await homeVM.getAllFood()
                }
            })
            .task {
                await homeVM.getAllFood()
            }
            .refreshable {
                await homeVM.getAllFood()
            }
            .alert("Oops...", isPresented: $homeVM.hasError) {} message: {
                Text(homeVM.homeError?.errorDescription ?? "You encountering an error")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.background)
            .navigationTitle("Home")
        }
    }
}

#Preview {
    NavigationStack{
        HomeView()
            .environmentObject(DrawerViewModel())
    }
}
