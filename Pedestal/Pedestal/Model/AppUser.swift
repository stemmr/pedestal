//
//  AppUser.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/31/24.
//
import Foundation
import FirebaseFirestore

struct AppUser: Codable {
    @DocumentID var id: String?
    var topics: [Topic]
    var name: String
}

// Maintain as a subcollection of user
struct UserBookmarks: Codable {
    @DocumentID var id: String? // Post ID
    var date: Date
}

// Maintain as a subcollection of user
struct UserPosts: Codable, Hashable {
    @DocumentID var id: String? // Post ID
    var topic: String
}

// Maintain as a subcollection of user
struct UserQuestions: Codable {
    @DocumentID var id: String? // Question ID
    var answered: Bool
    var points: Int
    
}
