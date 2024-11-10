//
//  UserViewModel.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 11/4/24.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore

@MainActor
class AppViewModel: ObservableObject {
    var userId: String
    let db: Firestore
    @Published var userTopics: [Topic] = []
    @Published var postViewModels: [PostViewModel] = []
    
    var defaultUserId = "0000-000-0000"
    
    init(
    ) {
        self.userId = defaultUserId
        self.db = Firestore.firestore()
        
        Task {
            self.userId = await createUserIfNotExists(userId: userId)
            print("Found User ID")
            self.userTopics = await getUserTopics(userId: userId)
            for topic in userTopics {
//                print("Initializing PostViewModel for topic [\(topic.title)]")
                postViewModels.append(PostViewModel(
                    topic: topic.id,
                    userId: self.userId
                ))
            }
        }
    }
    
    func getUserTopics(userId: String) async -> [Topic] {
        var topics: [Topic] = []
        do {
            let topicSnapshot = try await db.collection("users").document(userId)
                .collection("topics").getDocuments()
            for topic in topicSnapshot.documents {
                topics.append(
                    Topic(
                        id: topic.documentID,
                        title: topic.documentID,
                        points: topic["points"] as? Int ?? 0
                    )
                )
            }
        } catch {
            print("Could not load Topics for user with ID: \(userId)")
        }
        return topics
    }
    
    func createUserIfNotExists(userId: String) async -> String {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        do {
            let document = try await userRef.getDocument()
            if !document.exists {
                print("Creating account with \(userId)")
                let newUser = AppUser(
                    id: userId,
                    topics: [
                        Topic(id: "history", title: "History", points: 0),
                        Topic(id: "biology", title: "Biology", points: 0),
                        Topic(id: "arthistory", title: "Art History", points: 0),
                        Topic(id: "physics", title: "Physics", points: 0)
                    ],
                    name: "John Smith"
                )
                try userRef.setData(from: newUser)
            }
        } catch {
            print("Could not create or retrieve user \(userId)")
        }
        return userId
    }
}
