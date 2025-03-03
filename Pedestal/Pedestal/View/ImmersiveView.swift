//
//  ImmesiveView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 3/3/25.
//

import SwiftUI
import MarkdownUI

struct ImmersiveView: View {
    @EnvironmentObject var postViewModel: PostViewModel
    @Binding var post: Post
    @State private var navigateToPost: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with title and bookmark button
            HStack {
                Text(post.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.title.color)
                    .lineLimit(2)
                
                Spacer()
                
                Button(action: {
                    postViewModel.toggleBookmark(postId: post.id)
                }) {
                    Image(systemName: post.bookmarked ? "bookmark.fill" : "bookmark")
                        .font(.title3)
                        .foregroundColor(post.bookmarked ? .orange : .gray)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Content preview with disabled scrolling
            VStack {
                Markdown(post.content.replacingOccurrences(of: "\\n", with: "\n"))
                    .font(.subheadline)
                    .foregroundColor(Theme.subtitle.color)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: UIScreen.main.bounds.height * 0.6) // Limit height to 60% of screen
            .clipped() // Prevent content from overflowing
            .mask(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black,
                        Color.black,
                        Color.black,
                        Color.black,
                        Color.black,
                        Color.black,
                        Color.black,
                        Color.black.opacity(0.8),
                        Color.black.opacity(0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(UIColor.systemBackground))
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 1)
        }
        .onTapGesture {
            navigateToPost = true
        }
        .navigationDestination(isPresented: $navigateToPost) {
            PostView(post: $post)
                .navigationBarTitle(post.title, displayMode: .inline)
        }
    }
}

struct ScrollableImmersiveView: View {
    @StateObject var timelineViewModel: TimelineViewModel
    @State private var currentIndex = 0
    @State private var scrollPosition: Int?
    
    init(topic: String) {
        _timelineViewModel = StateObject(wrappedValue: TimelineViewModel(topic: topic))
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(0..<timelineViewModel.posts.count, id: \.self) { index in
                    ImmersiveView(post: binding(for: index))
                        .containerRelativeFrame([.horizontal, .vertical])
                        .id(index)
                        .onAppear {
                            currentIndex = index
                            print("Viewing post: \(timelineViewModel.posts[index].title)")
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $scrollPosition)
        .scrollTargetBehavior(.paging)
        .scrollDisabled(false)
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .ignoresSafeArea(edges: [.horizontal, .bottom])
        .safeAreaInset(edge: .top) {
            Color.clear
                .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top ?? 47)
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    let threshold: CGFloat = 50
                    if value.translation.height < -threshold && currentIndex < timelineViewModel.posts.count - 1 {
                        // Swipe up - go to next post
                        withAnimation {
                            scrollPosition = currentIndex + 1
                        }
                    } else if value.translation.height > threshold && currentIndex > 0 {
                        // Swipe down - go to previous post
                        withAnimation {
                            scrollPosition = currentIndex - 1
                        }
                    }
                }
        )
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func binding(for index: Int) -> Binding<Post> {
        return Binding(
            get: { self.timelineViewModel.posts[index] },
            set: { self.timelineViewModel.posts[index] = $0 }
        )
    }
}
