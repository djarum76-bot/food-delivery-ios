//
//  ViewExtension.swift
//  FoodDelivery
//
//  Created by habil . on 06/01/24.
//

import SwiftUI

extension View{
    func fadeImage() -> some View {
        modifier(FadeImage())
    }
    
    func getRect() -> CGRect {
        UIScreen.main.bounds
    }
}
