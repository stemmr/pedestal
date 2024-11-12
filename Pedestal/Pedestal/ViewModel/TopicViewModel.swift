//
//  TopicViewModel.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 11/11/24.
//
import SwiftUI
import Combine

class TopicViewModel: ObservableObject {
    private let service: PedestalService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var topics: [Topic] = []
    
    init() {
        self.service = PedestalService.shared
        
        service.$topics
                .receive(on: DispatchQueue.main)
                .assign(to: \.topics, on: self)
                .store(in: &cancellables)
    }
}
