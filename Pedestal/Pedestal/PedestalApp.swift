//
//  PedestalApp.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/22/24.
//

import SwiftUI

@main
struct PedestalApp: App {
    var topics: [Topic] = []
    
    var body: some Scene {
        WindowGroup {
            ContentView(topics: topics)
        }
    }
}
