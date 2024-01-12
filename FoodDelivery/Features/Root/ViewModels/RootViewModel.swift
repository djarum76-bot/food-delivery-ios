//
//  RootViewModel.swift
//  FoodDelivery
//
//  Created by habil . on 06/01/24.
//

import SwiftUI

enum RootState: String, Codable {
    case introduction, authentication, drawer
}

@MainActor
final class RootViewModel: ObservableObject{
    @AppStorage(Constants.root) var root: RootState = RootState.introduction
}
