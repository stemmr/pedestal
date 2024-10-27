//
//  PedestalApp.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/22/24.
//

import SwiftUI

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
