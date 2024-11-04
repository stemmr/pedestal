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
            title: topic,
            points: 0
        )
        
        self.loadPosts()
        self.loadQuestionsQueue()
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
                    id: UUID().uuidString,
                    title: postResponse.title,
                    summary: postResponse.summary,
                    content: postResponse.content,
                    bookmarked: postResponse.bookmarked ?? false
                )
                let postQuestions: [MultipleChoiceQuestion] = postResponse.questions.map { questionResponse in
                    MultipleChoiceQuestion(
                        id: UUID().uuidString,
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
    
    func currentQuestion() -> (any Question)? {
        return questions.first
    }
    
    func answerMultipleChoiceQuestion(questionId: String, optionIndex: Int) -> Bool? {
        print("Answering  Multiple Choice Question: \(questionId) with \(optionIndex)")
        if let index = self.questions.firstIndex(where: {$0.id == questionId}) {
            let question: any Question = self.questions[index]
            
            if var mcq = question as? MultipleChoiceQuestion {
                let result = mcq.answer(optionIndex: optionIndex)
                self.questions[index] = mcq
                if result {
                    self.topic.points += mcq.points
                }
                
                // Mark the question as answered
                db.collection("users").document(userId).collection("questions").document(question.id)
                    .setData([
                        "answered": true,
                        "correct": result,
                        "points": question.points,
                        "timestamp": Date().timeIntervalSince1970
                    ])
                questions.removeAll { $0.id == questionId }
                return result
            }
        }
        return nil
    }
    
    func loadPosts() {
        // For now we will be gettinga all posts from Firestore.
        // Next: First call user collection and retrieve user's nextPosts and load those
        var loadedPosts: [Post] = []
        
        Task {
            let snapshot = try await db.collection("posts")
                .whereField("topic", isEqualTo: self.topic.title)
                .limit(to: 50)
                .getDocuments()
            for post in snapshot.documents {
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
        }
    }
    
    func loadQuestionsQueue() {
        var loadedQuestions: [any Question] = []
        Task {
            let userQuestions = try await db.collection("users").document(userId)
                .collection("questions")
                .whereField("answered", isEqualTo: false)
                .limit(to: 50)
                .getDocuments()
            
            var questionDocumentIds: [String] = []
            for questionId in userQuestions.documents {
                questionDocumentIds.append(questionId.documentID)
            }
            
            for questionId in questionDocumentIds {
                let question = try await db.collection("questions").document(questionId).getDocument()
                print("Found a question from Firebase: \(question["question"] as? String ?? "")")
                if let questionType = QuestionType(rawValue: question["type"] as? String ?? "") {
                    print("QuestionType \(questionType)")
                    switch questionType {
                    case .mcq:
                        loadedQuestions.append(MultipleChoiceQuestion(
                            id: question.documentID,
                            postId: question["postId"] as? String,
                            question: question["question"] as? String ?? "",
                            options: question["options"] as? [String] ?? [],
                            correctOptionIndex: question["correctOptionIndex"] as? Int ?? 0,
                            points: question["points"] as? Int ?? 0,
                            answered: false
                        ))
                    }
                }
            }
            print("Loaded Questions: \(loadedQuestions)")
            self.questions = loadedQuestions
        }
    }
}
