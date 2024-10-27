//
//  PostViewModel.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/26/24.
//

import Foundation

@MainActor
class PostViewModel: Identifiable, ObservableObject {
    let id: UUID
    let network: Bool = false
    @Published var topic: Topic
    @Published var posts: [Post] = []
    @Published var questions: [any Question] = []
    
    init(
        id: UUID = UUID(),
        topic: String
    ) {
        self.id = id
        // Always load from JSON for now, make network calls later
        let data: (topic: Topic, posts: [Post], questions: [any Question])
        if !network {
            data = PostViewModel.loadFromJSON(topic: topic)
        } else {
            data = PostViewModel.loadFromJSON(topic: topic)
        }
        self.topic = data.topic
        self.posts = data.posts
        self.questions = data.questions
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
                    content: postResponse.content
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
    
    func getNextQuestion() {
        
    }
    
}
