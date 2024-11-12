//
//  PostViewModel.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/26/24.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore

@MainActor
class PostViewModel: Identifiable, ObservableObject {
    let id: UUID
    let network: Bool = true
    let userId: String
    let db: Firestore
    
    @Published var loaded: Bool = false
    @Published var topic: Topic
    @Published var posts: [Post] = []
    @Published var questions: [any Question] = []
    
    init(
        id: UUID = UUID(),
        topic: String,
        userId: String
    ) {
        self.id = id
        self.userId = userId
        self.db = Firestore.firestore()
        // Always load from JSON for now, make network calls later
        self.topic = Topic(
            id: topic,
            title: topic,
            points: 0
        )
        
//        self.loadPosts()
//        self.loadQuestionsQueue()
    }
    
    var bookmarkedPosts: [Post] {
        self.posts.filter { $0.bookmarked }
    }
    
    func toggleBookmark(postId: String) {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        
        posts[index].bookmarked.toggle()
        let state = posts[index].bookmarked
        
        let bookmarkRef = db.collection("users")
            .document(self.userId)
            .collection("bookmarks")
            .document(postId)
        
        if state {
            bookmarkRef.setData([
                "timestamp": Date().timeIntervalSince1970
            ])
        } else {
            bookmarkRef.delete()
        }
    }
}
