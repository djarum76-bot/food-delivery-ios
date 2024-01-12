//
//  CheckoutView.swift
//  FoodDelivery
//
//  Created by habil . on 08/01/24.
//

import CoreLocation
import CoreLocationUI
import SwiftUI

struct CheckoutView: View {
    @StateObject private var checkoutVM = CheckoutViewModel()
    @EnvironmentObject private var drawerVM: DrawerViewModel
    @Environment(\.dismiss) var dismiss
    let orders: [Order]
    
    var body: some View {
        VStack(alignment: .leading){
            CheckoutData()
                .environmentObject(checkoutVM)
            
            Spacer()
            
            VStack{
                HStack{
                    Text("Total")
                    
                    Spacer()
                    
                    Text(orders.total(),format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .fontWeight(.semibold)
                }
                
                AppButton(text: "Return to Previous Page", isIntroduction: true){
                    withAnimation{
                        dismiss()
                    }
                }
                AppButton(text: "Proceed to Payment", isDisabled: checkoutVM.isDisabled){
                    checkoutVM.showingAlert.toggle()
                }
            }
            .padding(.horizontal, 50)
        }
        .task {
            await checkoutVM.getUserAddress()
        }
        .refreshable {
            await checkoutVM.getUserAddress()
        }
        .alert("", isPresented: $checkoutVM.showingAlert){
            Button("Cancel"){}
            Button("Proceed"){
                Task {
                    let isSuccess = await checkoutVM.checkoutOrder(orders: orders)
                    
                    if !isSuccess {
                        return
                    }
                    
                    withAnimation{
                        dismiss()
                        drawerVM.selectedTab = .history
                    }
                }
            }
        } message: {
            Text("Delivery to \(checkoutVM.address ?? "")")
                .font(.headline)
        }
        .alert("Oops...", isPresented: $checkoutVM.hasError) {} message: {
            Text(checkoutVM.checkoutError?.errorDescription ?? "You encountering an error")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
        .navigationTitle("Checkout")
    }
}

extension [Order] {
    func total() -> Int {
        var total = 0
        
        for order in self {
            total += order.price * order.quantity
        }
        
        return total
    }
}

#Preview {
    NavigationStack{
        CheckoutView(orders: [Order.example])
            .environmentObject(DrawerViewModel())
    }
}
