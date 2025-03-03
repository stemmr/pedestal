//
//  ImmesiveView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 3/3/25.
//

import SwiftUI

struct ImmersiveView: View {
    @EnvironmentObject var postViewModel: PostViewModel
    @Binding var post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(post.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Theme.title.color)
                .padding(.horizontal)
            
            Text(post.summary)
                .font(.subheadline)
                .foregroundColor(Theme.subtitle.color)
                .padding(.horizontal)
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    postViewModel.toggleBookmark(postId: post.id)
                }) {
                    Image(systemName: post.bookmarked ? "bookmark.fill" : "bookmark")
                        .font(.title)
                        .foregroundColor(post.bookmarked ? .orange : .gray)
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
    }
}

struct ScrollableImmersiveView: View {
    @StateObject var timelineViewModel: TimelineViewModel
    @State private var currentIndex = 0
    
    init(topic: String) {
        _timelineViewModel = StateObject(wrappedValue: TimelineViewModel(topic: topic))
    }
    
    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $currentIndex) {
                ForEach(Array(timelineViewModel.posts.enumerated()), id: \.element.id) { index, post in
                    ImmersiveView(post: binding(for: index))
                        .tag(index)
                        .rotationEffect(.degrees(0)) // Prevents SwiftUI bug with TabView
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func binding(for index: Int) -> Binding<Post> {
        return Binding(
            get: { self.timelineViewModel.posts[index] },
            set: { self.timelineViewModel.posts[index] = $0 }
        )
    }
    
}
