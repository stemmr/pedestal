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
    
    
    init() {
        print("--- Initializing Pedestal App ---")
        FirebaseApp.configure()
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
    }
    
    var body: some Scene {
        return WindowGroup {
            TopicsView()
        }
    }
}
