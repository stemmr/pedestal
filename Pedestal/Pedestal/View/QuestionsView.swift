//
//  QuestionsView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/25/24.
//

import SwiftUI

struct MultipleChoiceQuestionView: View {
    @EnvironmentObject var postViewModel: PostViewModel
    var question: MultipleChoiceQuestion
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text(question.question)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 16) {
                ForEach(question.options.indices, id: \.self) { index in
                    Button(action: {
                        let result = postViewModel.answerMultipleChoiceQuestion(questionId: question.id, optionIndex: index)
                        print("Result from question: \(result)")
                    }) {
                        Text(question.options[index])
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.secondaryHighlight.color)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                // Handle skip
            }) {
                Text("Skip")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
            }
            
            Spacer()
        }
    }
}

struct QuestionsView: View {
    @EnvironmentObject var postViewModel: PostViewModel
    
    var body: some View {
        if let question = postViewModel.currentQuestion() {
            if let mcq = question as? MultipleChoiceQuestion {
                MultipleChoiceQuestionView(question: mcq)
            } else {
                Text("Question Type is currently not supported")
            }
        } else {
            Text("No Questions At the Moment!")
        }
    }
}

#Preview {
    QuestionsView().environmentObject(PostViewModel(topic: "history", userId: "0"))
}
