//
//  PedestalApp.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/22/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
               didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        return true
    }
}

@main
struct PedestalApp: App {
    var topics: [String] = [
        "history",
        "biology",
        "arthistory",
        "physics"
    ]
    var postViewModels: [PostViewModel]
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        print("--- Initializing Pedestal App ---")
        postViewModels = []
        for topic in topics {
            postViewModels.append(
                PostViewModel(topic: topic)
            )
        }
    }
    
    var body: some Scene {
        return WindowGroup {
            ContentView(topics: self.postViewModels)
        }
    }
}
