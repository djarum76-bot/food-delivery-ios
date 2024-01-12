//
//  AppButton.swift
//  FoodDelivery
//
//  Created by habil . on 06/01/24.
//

import SwiftUI

struct AppButton: View {
    var text: String
    var isIntroduction: Bool
    var isDisabled: Bool
    var action: () -> Void
    
    init(text: String, isIntroduction: Bool = false, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.text = text
        self.isIntroduction = isIntroduction
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var background: Color {
        if isIntroduction {
            return .white
        } else {
            if isDisabled {
                return .gray
            } else {
                return Theme.primary
            }
        }
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .fontWeight(.semibold)
                .foregroundStyle(isIntroduction ? Theme.primary : .white)
                .frame(maxWidth: .infinity, minHeight: 70, maxHeight: 70)
                .background(background)
                .clipShape(.rect(cornerRadius: 30))
        }
        .disabled(isDisabled)
    }
}

#Preview {
    AppButton(text: "Get Started", action: {})
}
