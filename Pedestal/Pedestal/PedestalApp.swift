//
//  PedestalApp.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/22/24.
//

import SwiftUI

@main
struct PedestalApp: App {
    var topics: [Topic] = Topic.previewTopics
    @StateObject private var posts = Posts.preview
    
    var body: some Scene {
        WindowGroup {
            ContentView(topics: topics)
                .environmentObject(posts)
        }
    }
}
