//
//  Posts.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/24/24.
//

import Foundation

struct Post: Identifiable {
    let id: UUID
    let title: String
    let summary: String
    let content: String
    
    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        content: String
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.content = content
    }
}

@MainActor
class Posts: ObservableObject {
    @Published private(set) var posts: [Post] = []
    
    func addPost(post: Post) {
        self.posts.append(post)
    }
}

extension Posts {
    #if DEBUG
    static var preview: Posts {
        let posts = Posts()
        
        posts.addPost(post: Post(
            title: "Socrates: The Man Who Asked Why",
            summary: """
                     A philosopher who never wrote a word, Socrates profoundly impacted Western thought through dialogues and debates.
                     Learn about his unyielding quest for truth, his method of inquiry, and the trial that led to his execution—sparking discussions on ethics and justice that resonate today.
                     """,
            content: "Socrates"
        ))
        
        posts.addPost(post: Post(
            title: "The Trojan War: Myth Meets History",
            summary: """
                     Immortalized by Homer's epics, the Trojan War blurs the lines between legend and reality.
                     Examine archaeological findings and ancient texts that breathe life into heroes like Achilles and Hector, and ponder the true events that may have inspired this timeless saga.
                     """,
            content: """
            # Large Markdown Document
                        
            ## Introduction
            This is a sample of a large markdown document that demonstrates the scrolling capabilities and formatting of our view.
            
            ## Features
            
            ### Comfortable Reading Width
            The content is limited to a maximum width for optimal readability, but will adjust on smaller screens.
            
            ### Proper Spacing
            Paragraphs and headings have appropriate spacing to improve readability.
            
            ### Code Blocks
            ```swift
            func example() {
                print("Code blocks are properly formatted")
                print("With monospace font and background")
            }
            ```
            
            ### Blockquotes
            > Important quotes and callouts are styled distinctly
            > With proper indentation and borders
            
            ### Lists
            - List items are properly formatted
            - With appropriate spacing
            - And indentation
            
            ## Long Content Support
            
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
            
            ### Another Section
            
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
            
            [Link Example](https://example.com)
            """
        ))
        
        return posts
    }
    #endif
}
