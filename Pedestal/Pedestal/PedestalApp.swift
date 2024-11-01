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
    var postViewModels: [PostViewModel] = []
    var authUserId = "0000-000-0000"
    
    init() {
        print("--- Initializing Pedestal App ---")
        FirebaseApp.configure()
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        
        self.createUserIfNotExists()
        
        for topic in topics {
            postViewModels.append(
                PostViewModel(topic: topic, userId: authUserId)
            )
        }
    }
    
    func createUserIfNotExists() {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(authUserId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Account with ID \(authUserId) already exists")
            } else {
                do {
                    print("Creating account with \(authUserId)")
                    try docRef.setData(from: AppUser(
                        id: authUserId,
                        bookmarks: [],
                        posts: [],
                        questions: []
                    ))
                } catch {
                    print("Failed to create account with \(authUserId)")
                }
            }
        }
    }
    
    var body: some Scene {
        return WindowGroup {
            ContentView(topics: self.postViewModels)
        }
    }
}
