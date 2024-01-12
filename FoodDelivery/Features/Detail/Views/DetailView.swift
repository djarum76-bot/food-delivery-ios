//
//  DetailView.swift
//  FoodDelivery
//
//  Created by habil . on 08/01/24.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var detailVM = DetailViewModel()
    @EnvironmentObject private var drawerVM: DrawerViewModel
    @Environment(\.dismiss) var dismiss
    let foodID: Int
    
    var body: some View {
        VStack{
            VStack(alignment: .center){
                HStack{
                    Spacer()
                    
                    Image(decorative: "food-card")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                    Spacer()
                }
                
                Spacer()
                
                VStack(alignment: .center){
                    Text(detailVM.food?.name ?? "")
                        .font(.title)
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 5)
                    
                    Text(detailVM.food?.price ?? 0,format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Theme.primary)
                }
            }
            
            VStack(alignment: .leading){
                Spacer()
                
                VStack(alignment: .leading){
                    Text("Delivery info")
                        .bold()
                    
                    Text("Delivered between 30 - 60 minutes")
                        .foregroundStyle(.gray)
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment: .leading){
                    Text("Return policy")
                        .bold()
                    
                    Text("All our foods are double checked before leaving our stores so by any case you found a broken food please contact our hotline immediately")
                        .foregroundStyle(.gray)
                }
                
                Spacer()
            }
            
            Spacer()
            
            VStack{
                AppButton(text: "Return to Previous Page", isIntroduction: true){
                    withAnimation{
                        dismiss()
                    }
                }
                AppButton(text: "Add to Order"){
                    Task {
                        let isSuccess = await detailVM.addToOrder(foodID: foodID)
                        
                        if !isSuccess {
                            return
                        }
                        
                        withAnimation{
                            dismiss()
                            drawerVM.selectedTab = .order
                        }
                    }
                }
            }
        }
        .task {
            await detailVM.getFood(id: foodID)
        }
        .alert("Oops...", isPresented: $detailVM.hasError) {} message: {
            Text(detailVM.detailError?.errorDescription ?? "You encountering an error")
        }
        .padding(.horizontal, 50)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
        .toolbar{
            Button{
                withAnimation {
                    if detailVM.isFavorite {
                        Task {
                            await detailVM.removeFromFavorite(foodID: foodID)
                        }
                    } else {
                        Task {
                            await detailVM.addToFavorite(foodID: foodID)
                        }
                    }
                }
            } label: {
                Image(systemName: detailVM.isFavorite ? "heart.fill" : "heart")
            }
        }
    }
}

#Preview {
    NavigationStack{
        DetailView(foodID: 2)
            .environmentObject(DrawerViewModel())
    }
}
