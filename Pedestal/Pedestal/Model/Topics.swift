//
//  Topics.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/24/24.
//

import Foundation

class Topic: Identifiable, ObservableObject, Codable {
    let id: String
    let title: String
    var points: Int
    
    init(
        id: String,
        title: String,
        points: Int = 0
    ){
        self.id = id
        self.title = title
        self.points = points
    }
}


extension Topic {
    static var previewTopics: [Topic] {
        let topics: [Topic] = [
            Topic(id: UUID().uuidString, title: "History"),
            Topic(id: UUID().uuidString, title: "Physics"),
            Topic(id: UUID().uuidString, title: "Biology")
        ]
        return topics
    }
}
