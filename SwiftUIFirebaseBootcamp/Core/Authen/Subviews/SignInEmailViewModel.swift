//
//  SignInEmailViewModel.swift
//  SwiftUIFirebaseBootcamp
//
//  Created by Panachai Sulsaksakul on 1/8/25.
//

import Foundation

final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }

        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }

        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}
