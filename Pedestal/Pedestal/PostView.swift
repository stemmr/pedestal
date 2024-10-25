//
//  PostView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/23/24.
//

import SwiftUI
import MarkdownUI

struct PostView: View {
    @Binding var post: Post
    
    var body: some View {
        ScrollView {
            Markdown(post.content)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: .constant(Posts.preview.posts[3]))
    }
}
