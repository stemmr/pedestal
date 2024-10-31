//
//  PostViewModel.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/26/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

@MainActor
class PostViewModel: Identifiable, ObservableObject {
    let id: UUID
    let network: Bool = true
    let db: Firestore
    
    @Published var loaded: Bool = false
    @Published var topic: Topic
    @Published var posts: [Post] = []
    @Published var questions: [any Question] = []
    
    init(
        id: UUID = UUID(),
        topic: String
    ) {
        self.id = id
        self.db = Firestore.firestore()
        // Always load from JSON for now, make network calls later
        self.topic = Topic(
            title: topic,
            points: 0
        )
        
        self.loadPosts()
        
//        if !network {
//            data = PostViewModel.loadFromJSON(topic: topic)
//        } else {
//            data =
//        }
    }
    
    static func loadFromJSON(topic: String) -> (topic: Topic, posts: [Post], questions: [any Question]) {
        do {
            let response = try LocalDecoder.decodeJSON(file: "posts")
            print("Decoded content from JSON File")
            let topicResponse = response.content.filter { topicItem in
                topicItem.topic == topic
            }[0]
            // Should return empty posts / questions if fails
            let topic: Topic = Topic(
                title: topicResponse.topic,
                points: topicResponse.points
            )
            var posts: [Post] = []
            var questions: [any Question] = []
            
            topicResponse.posts.forEach { postResponse in
                let post = Post(
                    title: postResponse.title,
                    summary: postResponse.summary,
                    content: postResponse.content,
                    bookmarked: postResponse.bookmarked ?? false
                )
                let postQuestions: [MultipleChoiceQuestion] = postResponse.questions.map { questionResponse in
                    MultipleChoiceQuestion(
                        postId: post.id,
                        question: questionResponse.question,
                        options: questionResponse.options,
                        correctOptionIndex: questionResponse.correctOptionIndex,
                        points: questionResponse.points
                    )
                }
                posts.append(post)
                questions += postQuestions
            }
            return (topic, posts, questions)
        } catch {
            print("Error loading JSON: \(error)")
            return (Topic(title: topic), posts: [], questions: [])
        }
    }
    
    var bookmarkedPosts: [Post] {
        self.posts.filter { $0.bookmarked }
    }
    
    func currentQuestion() -> (any Question)? {
        let bookmarkedIds = Set(self.bookmarkedPosts.map { $0.id })
        for question in self.questions {
            if bookmarkedIds.contains(question.postId) && !question.answered {
                return question
            }
        }
        return nil
    }
    
    func answerMultipleChoiceQuestion(questionId: UUID, optionIndex: Int) -> Bool? {
        print("Answering  Multiple Choice Question: \(questionId) with \(optionIndex)")
        if let index = self.questions.firstIndex(where: {$0.id as! UUID == questionId}) {
            if var mcq = self.questions[index] as? MultipleChoiceQuestion {
                let correct = mcq.answer(optionIndex: optionIndex)
                self.questions[index] = mcq
                if correct {
                    self.topic.points += mcq.points
                }
                return correct
            }
        }
        return nil
    }
    
    func loadPosts() {
        // For now we will be gettinga all posts from Firestore.
        // Next: First call user collection and retrieve user's nextPosts and load those
        var loadedPosts: [Post] = []
        var loadedQuestions: [any Question] = []
        
        Task {
            let querySnapshot = try await self.db.collection("posts")
                .whereField("topic", isEqualTo: self.topic.title)
                .limit(to: 50)
                .getDocuments()
            for post in querySnapshot.documents {
                print("Found a post from Firebase! \(post["title"] as? String ?? "")")
                loadedPosts.append(Post(
                    id: post.documentID,
                    title: post["title"] as? String ?? "",
                    summary: post["summary"] as? String ?? "",
                    content: post["content"] as? String ?? "",
                    bookmarked: false
                ))
            }
            self.posts = loadedPosts
            print(self.posts)
            self.questions = loadedQuestions
        }
        
    }
    
}
