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
        VStack {
            Text(topic.title)
        }
        .frame(width: 100, height: 100)
        .background(.blue)
        .cornerRadius(12)
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
