//
//  ContentView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/22/24.
//

import SwiftUI

struct TopicView: View {
    let postViewModel: PostViewModel
    @ObservedObject var topic: Topic
    
    init(
        postViewModel: PostViewModel
    ) {
        self.postViewModel = postViewModel
        self.topic = postViewModel.topic
    }
    
    var body: some View {
        NavigationLink(destination: MainTabView()
            .environmentObject(self.postViewModel)
        ) {
            VStack {
                Text(topic.title)
            }
            .frame(width: 120, height: 160)
            .background(Theme.secondaryHighlight.color)
            .cornerRadius(12)
        }
    }
}

struct ContentView: View {
    let topics: [PostViewModel]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(topics) { postViewModel in
                        TopicView(postViewModel: postViewModel)
                    }
                }
                .padding()
            }
            .navigationTitle("Topics")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let postViewModel: PostViewModel = PostViewModel(topic: "history")
        ContentView(topics: [postViewModel])
    }
}
