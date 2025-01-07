//
//  AuthenticationManager.swift
//  SwiftUIFirebaseBootcamp
//
//  Created by Panachai Sulsaksakul on 12/28/24.
//

import Foundation
import FirebaseAuth

struct AuthResultDataModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
    case apple = "apple.com"
}

final class AuthenticationManager {
    // Singleton is not recommend in large application
    static let shared = AuthenticationManager()
    
    private init() {}
    
    func getAuthenticateUser() throws -> AuthResultDataModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthResultDataModel(user: user)
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                // Type of error
//                fatalError()
//                preconditionFailure()
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
//            print(provider.providerID)
        }
        
        return providers
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

// MARK: - SIGN IN EMAIL
extension AuthenticationManager {
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthResultDataModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthResultDataModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthResultDataModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthResultDataModel(user: authDataResult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updateEmail(to: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updatePassword(to: password)
    }
}

// MARK: - SIGN IN SSO (Single Sign-on)
extension AuthenticationManager {
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthResultDataModel {
        let credential = GoogleAuthProvider.credential(
            withIDToken: tokens.idToken,
            accessToken: tokens.accessToken
        )
        
        return try await signIn(credential: credential)
    }

    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthResultDataModel {
        let credential = OAuthProvider.credential(
            withProviderID: AuthProviderOption.apple.rawValue,
            idToken: tokens.token,
            rawNonce: tokens.nonce
        )
        
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthResultDataModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthResultDataModel(user: authDataResult.user)
    }
}
