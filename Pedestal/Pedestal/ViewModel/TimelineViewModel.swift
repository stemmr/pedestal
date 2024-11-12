//
//  TimelineViewModel.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 11/11/24.
//

import SwiftUI
import Combine

class TimelineViewModel: ObservableObject {
    private let service: PedestalService
    private var cancellables = Set<AnyCancellable>()
    
    let topic: String
    @Published var posts: [Post] = []
    
    init(topic: String) {
        self.service = PedestalService.shared
        self.topic = topic
        
        service.$posts
            .map { posts in
                posts.filter { post in
                    post.topic == self.topic
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.posts, on: self)
            .store(in: &cancellables)
    }
}
