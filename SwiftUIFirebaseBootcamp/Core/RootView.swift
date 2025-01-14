//
//  RootView.swift
//  SwiftUIFirebaseBootcamp
//
//  Created by Panachai Sulsaksakul on 12/29/24.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                NavigationStack {
                    ProductsView()
                    //                    ProfileView(showSignInView: $showSignInView)
                    //                    SettingsView(showSignInView: $showSignInView)
                }
            }
        }
        .onAppear() {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil ? true : false
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
