//
//  TimelineView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/22/24.
//

import SwiftUI

struct PostRowView: View {
    @Binding var post: Post

    var body: some View {
        NavigationLink(destination: PostView(post: $post)) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(post.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.title.color)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Button(action: {
                            post.toggleBookmark()
                        }) {
                            Image(systemName: post.bookmarked ? "bookmark.fill" : "bookmark")
                                .foregroundColor(post.bookmarked ? .orange : .gray)
                        }
                    }
                    Text(post.summary)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Theme.subtitle.color)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ScrollableTimelineView: View {
    @EnvironmentObject var postViewModel: PostViewModel
    
    init() {}
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach($postViewModel.posts) { $post in
                    VStack {
                        PostRowView(post: $post)
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))
                    }
                }
            }
        }
    }
}

#Preview {
    let postViewModel: PostViewModel = PostViewModel(topic: "History")
    ScrollableTimelineView()
        .environmentObject(postViewModel)
}

