//
//  HistoryItem.swift
//  FoodDelivery
//
//  Created by habil . on 08/01/24.
//

import SwiftUI

struct HistoryItem: View {
    let history: History
    
    var body: some View {
        HStack(alignment: .center){
            Image("food-card")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
                .padding(.vertical, 20)
            
            VStack(alignment: .leading){
                Text(history.name)
                    .font(.headline)
                    .lineLimit(1)
                    .padding(.bottom, 5)
                
                Text(
                    history.total,
                    format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .fontWeight(.semibold)
                .foregroundStyle(Theme.primary)
                
                HStack{
                    Text(formattedDate(dateString: history.createdAt))
                        .font(.caption2)
                    
                    Spacer()
                    
                    HStack(spacing: 0){
                        Image(systemName: "menucard")
                            .font(.caption2)
                        
                        Text("\(history.quantity)")
                            .font(.caption2)
                    }
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(.rect(cornerRadius: 30))
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
        .padding(.top)
    }
    
    func formattedDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        
        if let originalDate = dateFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMM yyyy, HH:mm"
            
            let resultString = outputFormatter.string(from: originalDate)
            return resultString
        } else {
            return dateString
        }
    }
}

#Preview {
    HistoryItem(history: History.example)
}
