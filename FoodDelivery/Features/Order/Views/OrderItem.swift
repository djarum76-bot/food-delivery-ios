//
//  OrderItem.swift
//  FoodDelivery
//
//  Created by habil . on 08/01/24.
//

import SwiftUI

struct OrderItem: View {
    @EnvironmentObject private var orderVM: OrderViewModel
    let order: Order
    
    var body: some View {
        HStack(alignment: .center){
            Image("food-card")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
                .padding(.vertical, 20)
            
            VStack(alignment: .leading){
                Text(order.name)
                    .font(.headline)
                    .lineLimit(1)
                    .padding(.bottom, 5)
                
                HStack(alignment: .center){
                    Text(
                        order.quantity * order.price,
                        format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.primary)
                    
                    Spacer()
                    
                    HStack{
                        Button{
                            let data = order
                            
                            withAnimation {
                                orderVM.removeFromLocalOrder(order: data)
                            }
                            
                            Task{
                                await orderVM.removeFromGlobalOrder(order: data)
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                        
                        HStack(alignment: .center){
                            Button{
                                if order.quantity == 1 {
                                    return
                                }
                                
                                Task {
                                    await orderVM.updateUserAddress(id: order.id, quantity: order.quantity - 1)
                                }
                            } label: {
                                Image(systemName: "minus")
                                    .foregroundStyle(.white)
                            }
                            
                            Text("\(order.quantity)")
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                            
                            Button{
                                Task {
                                    await orderVM.updateUserAddress(id: order.id, quantity: order.quantity + 1)
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 5)
                        .background(Theme.primary)
                        .clipShape(.rect(cornerRadius: 30))
                    }
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(.rect(cornerRadius: 30))
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
        .padding(.top)
    }
}

#Preview {
    OrderItem(order: Order.example)
        .environmentObject(OrderViewModel())
}
