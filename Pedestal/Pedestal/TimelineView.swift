//
//  TimelineView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/22/24.
//

import SwiftUI

struct Post: Identifiable {
    let id = UUID()
    let content: String
}

struct PostRowView: View {
    let post: Post

    var body: some View {
        Text(post.content)
            .font(.body)
            .padding(.vertical, 8)
    }
}

struct TimelineView: View {
    let posts: [Post]

    var body: some View {
        List(posts) { post in
            PostRowView(post: post)
        }
        .listStyle(PlainListStyle())
    }
}

extension TimelineView {
    static var samplePosts: [Post] = [
        Post(content: "Hello, world!"),
        Post(content: "Just had coffee."),
        Post(content: "SwiftUI is awesome!"),
    ]
}

// Preview provider for SwiftUI previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(posts: TimelineView.samplePosts)
    }
}
