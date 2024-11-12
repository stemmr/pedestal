//
//  ContentView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/22/24.
//

import SwiftUI

struct TopicView: View {
    let backgroundImage: Image?
    let topic: Topic
    
    init(
        backgroundImage: Image? = nil,
        topic: Topic
    ) {
        self.backgroundImage = backgroundImage
        self.topic = topic
    }
    
    var body: some View {
        NavigationLink(destination: MainTabView(topic: self.topic.id)) {
            GeometryReader { geometry in
                VStack {
                    Text(topic.title)
                        .font(.headline)
                        .foregroundStyle(Theme.title.color)
                        .padding()
                    Text("\(topic.points)")
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

struct TopicsView: View {
    @StateObject var viewModel = TopicViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.topics) { topic in
                        TopicView(
                            backgroundImage: Image(topic.title),
                            topic: topic
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Topics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AuthenticatedView() {
                        Text("You're signed in.")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .background(.yellow)
                    }) {
                        Image(systemName: "person.circle")
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}
