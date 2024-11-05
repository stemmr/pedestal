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
        let _ = print("Rendering \(post.content.replacingOccurrences(of: "\\n", with: "\n"))")
        ScrollView {
            Markdown(post.content.replacingOccurrences(of: "\\n", with: "\n"))
                .padding(.horizontal, 10)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: .constant(Post(
            id: UUID().uuidString,
            title: "The Rise and Fall of Julius Caesar",
            summary: """
                     From brilliant military commander to controversial dictator, Caesar's life shaped the course of Roman history.
                     Explore his conquest of Gaul, crossing of the Rubicon, and the dramatic events leading to his assassination on the Ides of March.
                     """,
            content: """
            # Julius Caesar: Rome's Most Famous Leader
            """
        )))
    }
}
