//
//  MainTabView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/25/24.
//

import SwiftUI

struct MainTabView: View {
    private let topic: String
    static let viewMode: ViewMode = .immersive
    
    enum ViewMode {
        case timeline
        case immersive
    }
    
    init(topic: String){
        self.topic = topic
    }
    
    var body: some View {
        TabView {
            Group {
                if MainTabView.viewMode == .timeline {
                    ScrollableTimelineView(topic: topic)
                } else {
                    ScrollableImmersiveView(topic: topic)
                }
            }
            .tabItem {
                Image(systemName: "globe.desk")
                Text("Explore")
            }
//            BookmarksView().tabItem {
//                    Image(systemName: "bookmark")
//                    Text("Saved")
//            }
            QuestionsView(topic: topic).tabItem {
                    Image(systemName: "book")
                    Text("Practice")
            }
        }
    }
}

#Preview {
    MainTabView(topic: "history")
}
