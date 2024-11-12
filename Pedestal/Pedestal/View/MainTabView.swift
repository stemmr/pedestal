//
//  MainTabView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/25/24.
//

import SwiftUI

struct MainTabView: View {
    private let topic: String
    
    init(topic: String){
        self.topic = topic
    }
    
    var body: some View {
        TabView {
            ScrollableTimelineView(topic: topic)
                .tabItem {
                    Image(systemName: "globe.desk")
                    Text("Explore")
            }
//            BookmarksView().tabItem {
//                    Image(systemName: "bookmark")
//                    Text("Saved")
//            }
//            QuestionsView().tabItem {
//                    Image(systemName: "book")
//                    Text("Practice")
//            }
        }
    }
}

#Preview {
    MainTabView(topic: "history")
}
