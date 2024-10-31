//
//  PedestalApp.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/22/24.
//

import FirebaseFirestore
import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct PedestalApp: App {
    var topics: [String] = [
        "history",
        "biology",
        "arthistory",
        "physics"
    ]
    var postViewModels: [PostViewModel]
    
    init() {
        print("--- Initializing Pedestal App ---")
        FirebaseApp.configure()
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        
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
