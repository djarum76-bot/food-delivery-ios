//
//  CheckoutData.swift
//  FoodDelivery
//
//  Created by habil . on 09/01/24.
//

import CoreLocationUI
import SwiftUI

struct CheckoutData: View {
    @EnvironmentObject private var checkoutVM: CheckoutViewModel
    
    var body: some View {
        VStack{
            Form{
                Section{
                    HStack{
                        Text(checkoutVM.formattedAddress.isEmpty ? "Press the button on the side to get your location automatically" : checkoutVM.formattedAddress)
                        
                        Spacer()
                        
                        LocationButton(.currentLocation){
                            checkoutVM.requestLocation()
                        }
                        .symbolVariant(.fill)
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.white)
                        .tint(Theme.primary)
                        .clipShape(.rect(cornerRadius: 20))
                        .font(.caption)
                    }
                } header: {
                    Text("Address details")
                        .font(.headline)
                        .foregroundStyle(.black)
                }
                .textCase(nil)
                .onChange(of: checkoutVM.address) { oldValue, newValue in
                    Task{
                        await checkoutVM.updateUserAddress()
                    }
                }
                
                Section{
                    ForEach(checkoutVM.payments, id: \.self) { payment in
                        Button{
                            withAnimation{
                                checkoutVM.changePayment(payment: payment)
                            }
                        } label: {
                            HStack{
                                Image(systemName: checkoutVM.payment == payment ? "largecircle.fill.circle" : "circle")
                                
                                Text(payment.rawValue)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                } header: {
                    Text("Payment method")
                        .font(.headline)
                        .foregroundStyle(.black)
                }
                .textCase(nil)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .padding(.horizontal, 25)
    }
}

#Preview {
    CheckoutData()
        .environmentObject(CheckoutViewModel())
}
