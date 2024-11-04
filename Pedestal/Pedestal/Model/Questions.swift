//
//  Questions.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/24/24.
//

import Foundation

protocol Question: Identifiable {
    var question: String { get }
    var postId: String? { get }
    var points: Int { get }
    var answered: Bool { get }
}

enum QuestionType: String {
    case mcq = "MultipleChoice"
}

struct MultipleChoiceQuestion: Question {
    let id: String
    let postId: String?
    let question: String
    let options: [String]
    let correctOptionIndex: Int
    let points: Int
    var answered: Bool
    
    init(
        id: String,
        postId: String?,
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
    
    mutating func answer(optionIndex: Int) -> Bool {
        self.answered = true
        return optionIndex == correctOptionIndex 
    }
}
