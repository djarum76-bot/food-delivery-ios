//
//  FilterButton.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import SwiftUI

struct FilterButton: View {
    var isActive: Bool
    var type: String
    var animation: Namespace.ID
    var action: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom){
            Button{
                action()
            } label: {
                Text(type)
                    .foregroundStyle(isActive ? Theme.primary : .gray)
                    .padding()
            }
            
            if isActive {
                Rectangle()
                    .frame(height: 3)
                    .foregroundColor(Theme.primary)
                    .clipShape(.capsule)
                    .matchedGeometryEffect(id: "TAB", in: animation)
            }
        }
    }
}

//#Preview {
//    FilterButton(isActive: true, type: "Foods", action: {})
//}
