//
//  QuestionsView.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/25/24.
//

import SwiftUI

struct QuestionsView: View {
    let question: MultipleChoiceQuestion = MultipleChoiceQuestion.previewQuestions[0]
    
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
                        // Handle answer selection
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

#Preview {
    QuestionsView()
}
