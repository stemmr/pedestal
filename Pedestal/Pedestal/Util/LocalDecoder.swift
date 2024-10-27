//
//  JSONDecoder.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/26/24.
//

import Foundation

struct ContentResponse: Decodable {
    let content: [TopicResponse]
}

struct TopicResponse: Decodable {
    let topic: String
    let points: Int
    let posts: [PostResponse]
}

struct PostResponse: Decodable {
    let title: String
    let summary: String
    let content: String
    let questions: [QuestionResponse]
    let bookmarked: Bool?
}

struct QuestionResponse: Decodable {
    let question: String
    let options: [String]
    let correctOptionIndex: Int
    let points: Int
}

public class LocalDecoder {
    
    static func decodeJSON(file: String) throws -> ContentResponse {
        print("Decoding JSON file \(file).json")
        guard let path = Bundle.main.path(forResource: file, ofType: "json") else {
            throw NSError(domain: "LocalDecoder", code: 1, userInfo: [NSLocalizedDescriptionKey: "File not found"])
        }
        
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(ContentResponse.self, from: data)
    }
    
}
