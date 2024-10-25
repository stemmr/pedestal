//
//  Questions.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/24/24.
//

import Foundation

// Protocol for different question types
protocol Question: Identifiable {
    var question: String { get }
    var postId: UUID { get }
    var points: Int { get }
    var answered: Bool { get }
}

// Multiple choice question implementation
struct MultipleChoiceQuestion: Question {
    let id: UUID
    let postId: UUID
    let question: String
    let options: [String]
    let correctOptionIndex: Int
    let points: Int
    let answered: Bool
    
    init(
        id: UUID = UUID(),
        postId: UUID,
        question: String,
        options: [String],
        correctOptionIndex: Int,
        points: Int,
        answered: Bool = false
    ) {
        self.id = id
        self.postId = postId
        self.question = question
        self.options = options
        self.correctOptionIndex = correctOptionIndex
        self.points = points
        self.answered = answered
    }
}

extension MultipleChoiceQuestion {
    static var previewQuestions: [MultipleChoiceQuestion] {
        [
            MultipleChoiceQuestion(
                postId: UUID(), // Would match a specific post ID in real usage
                question: "What event marked Caesar's decisive break with the Roman Senate?",
                options: [
                    "Conquest of Gaul",
                    "Alliance with Pompey", 
                    "Crossing the Rubicon",
                    "Becoming dictator"
                ],
                correctOptionIndex: 2,
                points: 10
            ),
            
            MultipleChoiceQuestion(
                postId: UUID(),
                question: "Which invention was central to powering the Industrial Revolution?",
                options: [
                    "Steam engine",
                    "Telephone",
                    "Light bulb", 
                    "Automobile"
                ],
                correctOptionIndex: 0,
                points: 5,
                answered: true
            ),
            
            MultipleChoiceQuestion(
                postId: UUID(),
                question: "What was the capital of the Byzantine Empire?",
                options: [
                    "Rome",
                    "Athens",
                    "Constantinople",
                    "Alexandria"
                ],
                correctOptionIndex: 2,
                points: 8
            )
        ]
    }
}
