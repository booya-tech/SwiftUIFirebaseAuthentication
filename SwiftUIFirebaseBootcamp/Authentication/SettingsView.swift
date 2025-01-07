//
//  SettingsView.swift
//  SwiftUIFirebaseBootcamp
//
//  Created by Panachai Sulsaksakul on 12/29/24.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var authProviders: [AuthProviderOption] = []
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticateUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "panachai@example.com"
        
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "password"
        
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
}

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print("something went wrong \(error)")
                    }
                }
            } label: {
                Text("Sign out")
            }
            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            
        }
        .onAppear {
            viewModel.loadAuthProviders()
        }
        .navigationTitle(Text("Settings"))
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}

extension SettingsView {
    private var emailSection: some View {
        Section {
            Button {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password Reset!")
                    } catch {
                        print("something went wrong \(error)")
                    }
                }
            } label: {
                Text("Reset Password")
            }
            Button {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("Password Update!")
                    } catch {
                        print("something went wrong \(error)")
                    }
                }
            } label: {
                Text("Update Password")
            }
            Button {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("Email Update!")
                    } catch {
                        print("something went wrong \(error)")
                    }
                }
            } label: {
                Text("Update Email")
            }
        } header: {
            Text("Email functions")
        }
    }
}
