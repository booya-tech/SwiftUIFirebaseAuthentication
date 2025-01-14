//
//  ProfileView.swift
//  SwiftUIFirebaseBootcamp
//
//  Created by Panachai Sulsaksakul on 1/8/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    let preferenceOptions: [String] = ["Sports", "Movies", "Books"]
    
    private func preferenceIsSelected(text: String) -> Bool {
        viewModel.user?.preferences?.contains(text) == true
    }
    
    var body: some View {
        List {
            if let user = viewModel.user {
                Text("UserId: \(user.userId)")
                
                if let isAnonymous = user.isAnonymous {
                    Text("Is Anonymous: \(isAnonymous.description.capitalized)")
                }
                
                Button {
                    viewModel.togglePremiumStatus()
                } label: {
                    Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
                }
                
                VStack {
                    HStack {
                        ForEach(preferenceOptions, id: \.self) { string in
                            let isSelected = preferenceIsSelected(text: string)
                            Button(string) {
                                if isSelected {
                                    viewModel.removeUserPreference(text: string)
                                } else {
                                    viewModel.addUserPreference(text: string)
                                }
                            }
                            .font(.headline)
                            .buttonStyle(.borderedProminent)
                            .tint(isSelected ? .green : .gray)
                        }
                    }
                    
                    Text("User preferences: \((user.preferences ?? []).joined(separator: ", "))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button("Favorite Movies: \(user.favouriteMovie?.title ?? "")") {
                    if user.favouriteMovie == nil {
                        viewModel.addFavoriteMovie()
                    } else {
                        viewModel.removeFavoriteMovie()
                    }
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    RootView()
//    NavigationStack {
//        ProfileView(showSignInView: .constant(false))
//    }
}
