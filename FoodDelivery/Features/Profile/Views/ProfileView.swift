//
//  ProfileView.swift
//  FoodDelivery
//
//  Created by habil . on 07/01/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var profileVM = ProfileViewModel()
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    HStack{
                        Image("user")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(.rect(cornerRadius: 10))
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 10))
                        
                        VStack(alignment: .leading){
                            Text(profileVM.user?.name ?? "")
                                .font(.headline)
                            
                            Text(profileVM.user?.email ?? "")
                                .foregroundStyle(.gray)
                            
                            if !profileVM.formattedAddress.isEmpty {
                                Text(profileVM.formattedAddress)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                } header: {
                    Text("Information")
                        .font(.headline)
                        .foregroundStyle(.black)
                }
                .textCase(nil)
            }
            .task {
                await profileVM.getUser()
            }
            .refreshable {
                await profileVM.getUser()
            }
            .background(Theme.background)
            .navigationTitle("Profile")
            .alert("Oops...", isPresented: $profileVM.hasError) {} message: {
                Text(profileVM.profileError?.errorDescription ?? "You encountering an error")
            }
        }
    }
}

#Preview {
    ProfileView()
}
