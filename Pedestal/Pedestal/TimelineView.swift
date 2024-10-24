//
//  TimelineView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/22/24.
//

import SwiftUI

struct PostRowView: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.title)
                .fontWeight(.semibold)
            Text(post.summary)
                
        }
        .font(.body)
    }
}

struct TimelineView: View {
    let postManager: Posts

    var body: some View {
        List(postManager.posts) { post in
            PostRowView(post: post)
        }
        .listStyle(PlainListStyle())
    }
}

struct ScrollableTimelineView: View {
    let postManager: Posts
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(postManager.posts) { post in
                    VStack {
                        PostRowView(post: post)
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                        Divider()
                    }
                }
            }
        }
        Text("Yolo")
    }
}

// Preview provider for SwiftUI previews
struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollableTimelineView(postManager: Posts.preview)
    }
}
