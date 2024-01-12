//
//  TabButton.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import SwiftUI

struct TabButton: View {
    var image: String
    var title: String
    var tab: TabDrawerState
    @Binding var selectedTab: TabDrawerState
    var animation: Namespace.ID
    
    var body: some View {
        Button{
            withAnimation(.spring){
                selectedTab = tab
            }
        } label: {
            HStack(spacing: 15) {
                Image(systemName: image)
                    .font(.title2)
                    .frame(width: 30)
                
                Text(title)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(selectedTab == tab ? Theme.primary : .white)
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
            .frame(maxWidth: getRect().width - 170, alignment: .topLeading)
            .background(
                ZStack{
                    if selectedTab == tab {
                        Color.white
                            .opacity(selectedTab == tab ? 1 : 0)
                            .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 12))
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
            )
        }
    }
}

#Preview {
    DrawerView()
        .environmentObject(DrawerViewModel())
        .environmentObject(RootViewModel())
}
