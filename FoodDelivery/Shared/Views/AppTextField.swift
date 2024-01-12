//
//  AppTextField.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import SwiftUI

struct AppTextField: View {
    let label: String
    @Binding var text: String
    let isSecure: Bool
    
    init(label: String, text: Binding<String>, isSecure: Bool = false) {
        self.label = label
        _text = text
        self.isSecure = isSecure
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text(label)
                .font(.headline)
                .foregroundStyle(.gray)
            
            ZStack(alignment: .bottom) {
                if isSecure {
                    SecureField("", text: $text)
                        .textInputAutocapitalization(.never)
                        .font(.headline)
                        .padding(.vertical, 10)
                        .foregroundColor(.black)
                } else {
                    TextField("", text: $text)
                        .textInputAutocapitalization(.never)
                        .font(.headline)
                        .padding(.vertical, 10)
                        .foregroundColor(.black)
                }
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black) // Customize the underline color if needed
            }
        }
    }
}

#Preview {
    AppTextField(label: "Email", text: .constant("asdasd"), isSecure: true)
}
