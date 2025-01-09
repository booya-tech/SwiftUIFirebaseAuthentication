//
//  SettingsView.swift
//  SwiftUIFirebaseBootcamp
//
//  Created by Panachai Sulsaksakul on 12/29/24.
//

import SwiftUI

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
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    } catch {
                        print("something went wrong \(error)")
                    }
                }
            } label: {
                Text("Delete account")
            }

            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }

            if let user = viewModel.authUser, user.isAnonymous {
                anonymousSection
            }
            
        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
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
    
    private var anonymousSection: some View {
        Section {
            Button {
                Task {
                    do {
                        try await viewModel.linkGoogleAccount()
                        print("GOOGLE LINKED!")
                    } catch {
                        print("something went wrong \(error)")
                    }
                }
            } label: {
                Text("Link Google Account")
            }
            Button {
                Task {
                    do {
                        try await viewModel.linkAppleAccount()
                        print("APPLE LINKED!")
                    } catch {
                        print("something went wrong \(error)")
                    }
                }
            } label: {
                Text("Link Apple Account")
            }
            Button {
                Task {
                    do {
                        try await viewModel.linkEmailAccount()
                        print("EMAIL LINKED!")
                    } catch {
                        print("something went wrong \(error)")
                    }
                }
            } label: {
                Text("Link Email Account")
            }
        } header: {
            Text("Create Account")
        }
    }
}
