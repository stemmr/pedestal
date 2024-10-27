//
//  ContentView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/22/24.
//

import SwiftUI

struct TopicView: View {
    @EnvironmentObject var postViewModel: PostViewModel
    let backgroundImage: Image?
    
    init(
        backgroundImage: Image? = nil
    ) {
        self.backgroundImage = backgroundImage
    }
    
    var body: some View {
        NavigationLink(destination: MainTabView()
            .environmentObject(self.postViewModel)
        ) {
            GeometryReader { geometry in
                VStack {
                    Text(postViewModel.topic.title)
                        .font(.headline)
                        .foregroundStyle(Theme.title.color)
                        .padding()
                    Text("\(postViewModel.topic.points)")
                        .font(.headline)
                        .foregroundStyle(Theme.title.color)

                        .padding()
                }
                .frame(width: geometry.size.width, height: geometry.size.width) // Makes it square based on available width
                .background(
                    backgroundImage?
                        .resizable()
                        .scaledToFill()
                        .overlay(Color.black.opacity(0.3)) // Darkens image for text readability
                )
                .cornerRadius(12)
            }
            .aspectRatio(1, contentMode: .fit) // Maintains square aspect ratio
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
                        TopicView(
                            backgroundImage: Image(postViewModel.topic.title)
                        ).environmentObject(postViewModel)
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
        ContentView(topics: [
            PostViewModel(topic: "history"),
            PostViewModel(topic: "biology"),
            PostViewModel(topic: "arthistory"),
            PostViewModel(topic: "physics")
        ])
    }
}
