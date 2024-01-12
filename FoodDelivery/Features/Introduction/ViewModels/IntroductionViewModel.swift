//
//  IntroductionViewModel.swift
//  FoodDelivery
//
//  Created by habil . on 09/01/24.
//

import Foundation

@MainActor
final class IntroductionViewModel: ObservableObject{
    let timer = Timer.publish(every: 0.75, on: .main, in: .common).autoconnect()
    @Published var counter = 0
    
    @Published var showingFirst = false
    @Published var showingSecond = false
    @Published var showingThird = false
}
