//
//  HistoryView.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var historyVM = HistoryViewModel()
    
    var body: some View {
        NavigationStack{
            VStack {
                if historyVM.histories.isEmpty {
                    VStack{
                        VStack(spacing: 10){
                            Spacer()
                            
                            Image(systemName: "calendar")
                                .font(.system(size: 150))
                                .foregroundStyle(.gray)
                            
                            Text("No history yet")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                            
                            Text("Hit the orange button down\nbelow to create an order")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.gray)
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        AppButton(text: "Start Ordering") {}
                            .padding(.horizontal, 50)
                    }
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(historyVM.histories) { history in
                                HistoryItem(history: history)
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                }
            }
            .task {
                await historyVM.getAllOrder()
            }
            .refreshable {
                await historyVM.getAllOrder()
            }
            .alert("Oops...", isPresented: $historyVM.hasError) {} message: {
                Text(historyVM.historyError?.errorDescription ?? "You encountering an error")
            }
            .background(Theme.background)
            .scrollBounceBehavior(.basedOnSize)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("History")
        }
    }
}

#Preview {
    HistoryView()
}
