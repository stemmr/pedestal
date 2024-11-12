//
//  PedestalService.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 11/11/24.
//

import FirebaseCore
import FirebaseFirestore
import Combine


class PedestalService: ObservableObject {
    static let shared = PedestalService()
    
    @Published var posts: [Post] = []
    @Published var topics: [Topic] = []
    
    private var postSubscribers: [String: ListenerRegistration] = [:]
    
    var userId = "0000-000-0000"
    let db: Firestore
    
    init() {
        self.db = Firestore.firestore()
        // TODO: Get userId from Auth
        self.registerTopicSubscriber()
    }
    
    func registerPostSubscriber(topic: String) {
        if postSubscribers[topic] != nil {
            // A subscriber already exists for this topic, so do nothing
            print("Subscriber for topic '\(topic)' already exists.")
            return
        }
        
        let listener = db.collection("posts").whereField("topic", isEqualTo: topic)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let newPosts = documents.map { post -> Post in
                    return Post(
                        id: post.documentID,
                        topic: topic,
                        title: post["title"] as? String ?? "",
                        summary: post["summary"] as? String ?? "",
                        content: post["content"] as? String ?? "",
                        bookmarked: false
                    )
                }
                
                DispatchQueue.main.async {
                    for newPost in newPosts {
                        if !self.posts.contains(where: { $0.id == newPost.id }) {
                            self.posts.append(newPost)
                            print("Added new post: \(newPost.title)")
                        } else {
                            print("Post with id \(newPost.id) already exists.")
                        }
                    }
                }
            }
        postSubscribers[topic] = listener
        print("Subscriber for topic '\(topic)' has been added.")
    }
    
    func deregisterPostSubscriber(topic: String) {
        // Check if a subscriber for this topic exists
        if let listener = postSubscribers[topic] {
            // Remove the listener
            listener.remove()
            // Remove the listener from the dictionary
            postSubscribers.removeValue(forKey: topic)
            print("Subscriber for topic '\(topic)' has been removed.")
        } else {
            print("No subscriber found for topic '\(topic)'.")
        }
    }
        
    func registerTopicSubscriber() {
        db.collection("users").document(userId)
            .collection("topics").addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                let newTopics = documents.map { topic -> Topic in
                    let newTopic = Topic(
                        id: topic.documentID,
                        title: topic.documentID,
                        points: topic["points"] as? Int ?? 0
                    )
                    self.registerPostSubscriber(topic: newTopic.id)
                    return newTopic
                }
                
                // Update the topics array on the main thread
                DispatchQueue.main.async {
                    self.topics = newTopics
                }
            }
    }
    
    func registerQuestionsSubscriber(topic: String) {
        
    }
    
}
