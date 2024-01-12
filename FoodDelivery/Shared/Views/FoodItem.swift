//
//  FoodItem.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import SwiftUI

struct FoodItem: View {
    @EnvironmentObject private var drawerVM: DrawerViewModel
    let food: Food
    
    var body: some View {
        NavigationLink {
            DetailView(foodID: food.id)
                .environmentObject(drawerVM)
                .navigationBarBackButtonHidden()
        } label: {
            ZStack(alignment: .top){
                VStack{
                    Spacer()
                    
                    VStack{
                        Spacer().frame(height: 75)
                        
                        Text(food.name)
                            .font(.system(size: 22))
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                        
                        Text(
                            food.price,
                            format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .font(.headline)
                            .foregroundStyle(Theme.primary)
                    }
                    .frame(maxWidth: 175, maxHeight: 230)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 30))
                }
                .frame(maxWidth: 175, maxHeight: 300)
                
                Image(decorative: "food-1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 250)
            }
            .frame(width: 225, height: 300)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        }

    }
}

#Preview {
    FoodItem(food: Food.example)
        .environmentObject(DrawerViewModel())
}
