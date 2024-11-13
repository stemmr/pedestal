//
//  BookmarksViewModel.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 11/11/24.
//
import SwiftUI
import Combine

class BookmarksViewModel: ObservableObject {
    private let service: PedestalService
    private var cancellables = Set<AnyCancellable>()
    
    let topic: String
    @Published var bookmarks: [Post] = []
    
    init(topic: String) {
        self.service = PedestalService.shared
        self.topic = topic
        
        service.$bookmarks
    }
}
