//
//  PostViewModel.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/26/24.
//

import Foundation

@MainActor
class PostViewModel: ObservableObject {
    let topic: String
    let network: Bool = false
    @Published var posts: [Post] = []
    @Published var questions: [any Question] = []
    
    init(topic: String) {
        self.topic = topic
        if !network {
            let data = PostViewModel.loadFromJSON(topic: topic)
            self.posts = data.posts
            self.questions = data.questions
        } else {
            print("Retrieveing posts from network not yet supported!")
        }
    }
    
    static func loadFromJSON(topic: String) -> (posts: [Post], questions: [any Question]) {
        do {
            let response = try LocalDecoder.decodeJSON(file: "posts")
            print("Decoded content from JSON File")
//            let posts = response.posts.map { postResponse in
//                Post(title: postResponse.title,
//                     summary: postResponse.summary,
//                     content: postResponse.content)
//            }
//            print("Loaded Posts from JSON")
//            let questions = response.posts.flatMap { postResponse in
//                postResponse.questions.map { questionResponse in
//                    MultipleChoiceQuestion(
//                        postId: UUID(), // Needs to be updated to match with actual Post
//                        question: questionResponse.question,
//                        options: questionResponse.options,
//                        correctOptionIndex: questionResponse.correctOptionIndex,
//                        points: questionResponse.points
//                    )
//                }
//            }
//            return (posts: posts, questions: questions)
            return (posts: [], questions: [])
        } catch {
            print("Error loading JSON: \(error)")
            return (posts: [], questions: [])
        }
    }
    
    func getNextQuestion() {
        
    }
    
}
