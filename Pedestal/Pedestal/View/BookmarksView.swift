//
//  BookmarksView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/25/24.
//

import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject var postViewModel: PostViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(postViewModel.bookmarkedPosts.indices, id: \.self) { index in
                    if let originalIndex = postViewModel.posts.firstIndex(where: { $0.id == postViewModel.bookmarkedPosts[index].id }) {
                        VStack {
                            PostRowView(post: $postViewModel.posts[originalIndex])
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
        .environmentObject(PostViewModel(topic: "history"))
}
