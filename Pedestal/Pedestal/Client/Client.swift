//
//  Client.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/29/24.
//

import Foundation

struct Message: Codable {
    let message: String
}

class Client {
    
    func fetchPosts() async throws -> Message {
        // Construct the URL
        guard let url = URL(string: "https://c24plrdcm6.execute-api.us-east-1.amazonaws.com/Prod/posts/") else {
            throw URLError(.badURL)
        }

        // Perform the network request using URLSession
        let (data, response) = try await URLSession.shared.data(from: url)

        // Validate the HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        // Decode the JSON data into an array of Post
        let decoder = JSONDecoder()
        let posts = try decoder.decode(Message.self, from: data)
        return posts
    }
}
