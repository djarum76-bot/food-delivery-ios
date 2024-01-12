//
//  CartView.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import SwiftUI

struct OrderView: View {
    @StateObject private var orderVM = OrderViewModel()
    @EnvironmentObject private var drawerVM: DrawerViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                if orderVM.orders.isEmpty {
                    VStack(spacing: 10){
                        Spacer()
                        
                        Image(systemName: "cart")
                            .font(.system(size: 150))
                            .foregroundStyle(.gray)
                        
                        Text("No orders yet")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        
                        Text("Hit the orange button down\nbelow to create an order")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.gray)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    AppButton(text: "Start Ordering") {
                        withAnimation {
                            drawerVM.selectedTab = .home
                        }
                    }
                        .padding(.horizontal, 50)
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(orderVM.orders) { order in
                                OrderItem(order: order)
                                    .environmentObject(orderVM)
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                    
                    NavigationLink{
                        CheckoutView(orders: orderVM.orders)
                            .environmentObject(drawerVM)
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("Proceed to checkout")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, minHeight: 70, maxHeight: 70)
                            .background(Theme.primary)
                            .clipShape(.rect(cornerRadius: 30))
                    }
                    .padding(.horizontal, 50)
                    .padding(.top, 10)
                }
            }
            .task {
                await orderVM.getAllOrder()
            }
            .refreshable {
                await orderVM.getAllOrder()
            }
            .alert("Oops...", isPresented: $orderVM.hasError) {} message: {
                Text(orderVM.orderError?.errorDescription ?? "You encountering an error")
            }
            .background(Theme.background)
            .scrollBounceBehavior(.basedOnSize)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Order")
        }
    }
}

#Preview {
    OrderView()
        .environmentObject(DrawerViewModel())
}
