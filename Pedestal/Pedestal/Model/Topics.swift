//
//  Topics.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/24/24.
//

import Foundation

class Topic: Identifiable, ObservableObject {
    let id: UUID
    let title: String
    
    init(
        id: UUID = UUID(),
        title: String
    ){
        self.id = id
        self.title = title
    }
}


extension Topic {
    static var previewTopics: [Topic] {
        let topics: [Topic] = [
            Topic(title: "History"),
            Topic(title: "Physics"),
            Topic(title: "Biology")
        ]
        return topics
    }
}
