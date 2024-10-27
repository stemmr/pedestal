//
//  BookmarksView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/25/24.
//

import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject var postManager: Posts
    
    var bookmarkedPosts: [Post] {
        postManager.posts.filter { $0.bookmarked }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(bookmarkedPosts.indices, id: \.self) { index in
                    if let originalIndex = postManager.posts.firstIndex(where: { $0.id == bookmarkedPosts[index].id }) {
                        VStack {
                            PostRowView(post: $postManager.posts[originalIndex])
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
}

#Preview {
    BookmarksView()
        .environmentObject(Posts.preview)
}
