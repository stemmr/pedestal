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
    @Published var questions: [any Question] = []
    
    private var postSubscribers: [String: ListenerRegistration] = [:]
    private var questionSubscribers: [String: ListenerRegistration] = [:]
    
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
            print("Post Subscriber for topic '\(topic)' already exists.")
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
        print("Post Subscriber for topic '\(topic)' has been added.")
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
                    self.registerQuestionsSubscriber(topic: newTopic.id)
                    return newTopic
                }
                
                // Update the topics array on the main thread
                DispatchQueue.main.async {
                    self.topics = newTopics
                }
            }
    }
    
    func registerQuestionsSubscriber(topic: String) {
        if questionSubscribers[topic] != nil {
            // A subscriber already exists for this topic, so do nothing
            print("Question Subscriber for topic '\(topic)' already exists.")
            return
        }
        let listener = db.collection("users").document(userId)
            .collection("questions")
            .whereField("answered", isEqualTo: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                var questionDocumentIds: [String] = []
                for questionId in documents {
                    questionDocumentIds.append(questionId.documentID)
                }
                
                let batches = stride(from: 0, to: questionDocumentIds.count, by: 10).map {
                    Array(questionDocumentIds[$0..<min($0 + 10, questionDocumentIds.count)])
                }
                            
                for batch in batches {
                    self.db.collection("questions")
                        .whereField(FieldPath.documentID(), in: batch)
                        .getDocuments { [weak self] (querySnapshot, error) in
                            guard let self = self else { return }
                            guard let querySnapshot = querySnapshot else {
                                print("Error fetching questions: \(error?.localizedDescription ?? "Unknown error")")
                                return
                            }
                            
                            for document in querySnapshot.documents {
                                let data = document.data()
                                print("Found a question from Firebase: \(data["question"] as? String ?? "")")
                                if let questionTypeString = data["type"] as? String,
                                   let questionType = QuestionType(rawValue: questionTypeString) {
                                    print("QuestionType \(questionType)")
                                    switch questionType {
                                    case .mcq:
                                        let newQuestion = MultipleChoiceQuestion(
                                            id: document.documentID,
                                            postId: data["postId"] as? String,
                                            topic: topic,
                                            question: data["question"] as? String ?? "",
                                            options: data["options"] as? [String] ?? [],
                                            correctOptionIndex: data["correctOptionIndex"] as? Int ?? 0,
                                            points: data["points"] as? Int ?? 0,
                                            answered: false
                                        )
                                        // Update questions on the main thread
                                        DispatchQueue.main.async {
                                            self.questions.append(newQuestion)
                                        }
                                    }
                                }
                            }
                        }
                }
            }
        questionSubscribers[topic] = listener
        print("Question Subscriber for topic '\(topic)' has been added.")
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
    
    func answerQuestion(questionId: String, result: Bool) {
        db.collection("users").document(userId).collection("questions").document(questionId)
            .setData([
                "answered": true,
                "correct": result,
                "timestamp": Date().timeIntervalSince1970
            ], merge: true)
        questions.removeAll { $0.id == questionId }
    }
    
}
