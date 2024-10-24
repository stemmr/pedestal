//
//  PostView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/23/24.
//

import SwiftUI
import MarkdownUI

struct PostView: View {
    let markdownContent: String
    
    var body: some View {
        Markdown(markdownContent)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(markdownContent: Posts.preview.posts[0].content)
    }
}
