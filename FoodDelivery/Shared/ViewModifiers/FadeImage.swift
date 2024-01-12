//
//  FadeImage.swift
//  FoodDelivery
//
//  Created by habil . on 06/01/24.
//

import SwiftUI

struct FadeImage: ViewModifier{
    func body(content: Content) -> some View {
        content
            .mask(LinearGradient(gradient: Gradient(stops: [
                .init(color: .black, location: 0),
                .init(color: .black, location: 0.65),
                .init(color: .clear, location: 0.82)
            ]), startPoint: .top, endPoint: .bottom))
    }
}
