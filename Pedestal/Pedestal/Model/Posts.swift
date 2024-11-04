//
//  Posts.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/24/24.
//

import Foundation
import FirebaseFirestore

struct Post: Codable, Identifiable {
    let id: String
    let title: String
    let summary: String
    let content: String
    var bookmarked: Bool
    
    init(
        id: String,
        title: String,
        summary: String,
        content: String,
        bookmarked: Bool = false
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.content = content
        self.bookmarked = bookmarked
    }
    
    mutating func toggleBookmark() {
        print("Bookmark toggled for post: \(title)")
        self.bookmarked = !self.bookmarked
    }
}
