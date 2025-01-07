//
//  SwiftUIFirebaseBootcampApp.swift
//  SwiftUIFirebaseBootcamp
//
//  Created by Panachai Sulsaksakul on 11/26/24.
//

import SwiftUI
import Firebase

@main
struct SwiftUIFirebaseBootcampApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Configured Firebase")
        return true
    }
}
