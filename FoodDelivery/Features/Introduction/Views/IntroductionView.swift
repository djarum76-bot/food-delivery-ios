//
//  IntroductionView.swift
//  FoodDelivery
//
//  Created by habil . on 06/01/24.
//

import SwiftUI

struct IntroductionView: View {
    @StateObject private var introductionVM = IntroductionViewModel()
    @EnvironmentObject private var rootVM: RootViewModel
    
    var body: some View {
        ZStack{
            Theme.primary
            
            Image(decorative: "toy2")
                .opacity(introductionVM.showingFirst ? 1 : 0)
                .position(x: 300, y: 600)
                .fadeImage()
            
            Image(decorative: "toy1")
                .opacity(introductionVM.showingSecond ? 1 : 0)
                .position(x: 150, y: 550)
                .fadeImage()
            
            VStack(alignment: .leading){
                Spacer().frame(height: 20)
                
                Image(decorative: "logo-small")
                    .padding()
                    .background(.white)
                    .clipShape(.circle)
                    .opacity(introductionVM.showingThird ? 1 : 0)
                
                Text("Food for Everyone")
                    .opacity(introductionVM.showingThird ? 1 : 0)
                    .font(.system(size: 65))
                    .fontDesign(.rounded)
                    .fontWeight(.heavy)
                    .foregroundStyle(.white)
                
                Spacer()
                
                AppButton(text: "Get Started", isIntroduction: true){
                    withAnimation{
                        rootVM.root = .authentication
                    }
                }
                .opacity(introductionVM.showingThird ? 1 : 0)
            }
            .padding(.horizontal, 50)
            .padding(.vertical, 36)
        }
        .ignoresSafeArea()
        .onReceive(introductionVM.timer) { time in
            withAnimation(.spring){
                switch introductionVM.counter{
                case 0:
                    introductionVM.showingFirst.toggle()
                case 1:
                    introductionVM.showingSecond.toggle()
                case 2:
                    introductionVM.showingThird.toggle()
                default:
                    introductionVM.timer.upstream.connect().cancel()
                }
                
                introductionVM.counter += 1
            }
        }
    }
}

#Preview {
    IntroductionView()
        .environmentObject(RootViewModel())
}
