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
        Text("Hello, World!")
    }
}

struct ScrollableImmersiveView: View {
    @StateObject var timelineViewModel: TimelineViewModel
    
    init(topic: String) {
        _timelineViewModel = StateObject(wrappedValue: TimelineViewModel(topic: topic))
    }
    
    var body: some View {
        Text("Hello Immersion!")
    }
}
