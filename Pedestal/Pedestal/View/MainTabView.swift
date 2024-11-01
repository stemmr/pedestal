//
//  MainTabView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/25/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ScrollableTimelineView()
                .tabItem {
                    Image(systemName: "globe.desk")
                    Text("Explore")
            }
            BookmarksView().tabItem {
                    Image(systemName: "bookmark")
                    Text("Saved")
            }
            QuestionsView().tabItem {
                    Image(systemName: "book")
                    Text("Practice")
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(PostViewModel(topic: "history", userId: "0"))
}
