//
//  FavoriteView.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import SwiftUI

struct FavoriteView: View {
    @StateObject private var favoriteVM = FavoriteViewModel()
    @EnvironmentObject private var drawerVM: DrawerViewModel
    @Namespace var animation
    
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(favoriteVM.types, id: \.self){ type in
                            FilterButton(isActive: favoriteVM.type == type, type: type, animation: animation) {
                                withAnimation{
                                    favoriteVM.changeType(type: type)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                
                Spacer().frame(height: 10)
                
                if favoriteVM.foods.isEmpty && favoriteVM.networkingState != .loading {
                    VStack(spacing: 10){
                        Spacer()
                        
                        Image(systemName: "fork.knife")
                            .font(.system(size: 150))
                            .foregroundStyle(.gray)
                        
                        Text("No favorite food yet")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        
                        Spacer()
                    }
                } else {
                    ScrollView{
                        LazyVGrid(columns: favoriteVM.columns, spacing: 0){
                            ForEach(favoriteVM.foods){ food in
                                FoodItem(food: food)
                                    .environmentObject(drawerVM)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }
            .onChange(of: favoriteVM.type, { oldValue, newValue in
                Task {
                    await favoriteVM.getAllFavoriteFood()
                }
            })
            .task {
                await favoriteVM.getAllFavoriteFood()
            }
            .refreshable {
                await favoriteVM.getAllFavoriteFood()
            }
            .alert("Oops...", isPresented: $favoriteVM.hasError) {} message: {
                Text(favoriteVM.favoriteError?.errorDescription ?? "You encountering an error")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.background)
            .navigationTitle("Favorite")
        }
    }
}

#Preview {
    FavoriteView()
        .environmentObject(DrawerViewModel())
}
