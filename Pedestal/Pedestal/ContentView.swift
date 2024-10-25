//
//  ContentView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/22/24.
//

import SwiftUI

struct TopicView: View {
    @ObservedObject var topic: Topic
    
    var body: some View {
        NavigationLink(destination: ScrollableTimelineView(postManager: Posts.preview)) {
            VStack {
                Text(topic.title)
            }
            .frame(width: 120, height: 160)
            .background(Theme.secondary.color)
            .cornerRadius(12)
        }
    }
}

struct ContentView: View {
    let topics: [Topic]
    
    var body: some View {
        TopicView(topic: topics[0])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(topics: Topic.previewTopics)
    }
}
