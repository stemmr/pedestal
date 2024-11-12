//
//  QuestionsViewModel.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 11/11/24.
//

import SwiftUI
import Combine

class QuestionsViewModel: ObservableObject {
    private let service: PedestalService
    private var cancellables = Set<AnyCancellable>()
    
    let topic: String
    @Published var questions: [any Question] = []
    
    init(topic: String) {
        self.service = PedestalService.shared
        self.topic = topic
        
        service.$questions
            .map { questions in
                questions.filter { question in
                    question.topic == self.topic
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.questions, on: self)
            .store(in: &cancellables)
    }
    
    func currentQuestion() -> (any Question)? {
        return questions.first
    }
    
    func answerMultipleChoiceQuestion(questionId: String, optionIndex: Int) -> Bool? {
        print("Answering Multiple Choice Question: \(questionId) with \(optionIndex)")
        if let index = self.questions.firstIndex(where: {$0.id == questionId}) {
            let question: any Question = self.questions[index]
            
            if var mcq = question as? MultipleChoiceQuestion {
                let result = mcq.answer(optionIndex: optionIndex)
                self.questions[index] = mcq
                
                // Mark the question as answered
                service.answerQuestion(questionId: questionId, result: result)
                return result
            }
        }
        return nil
    }
}
