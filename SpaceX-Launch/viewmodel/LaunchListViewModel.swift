//
//  LaunchListViewModel.swift
//  spacex-launches
//
//  Created by oktay on 14.12.2024.
//

import Foundation
import SwiftUI
import Combine

class LaunchListViewModel: ObservableObject {
    
    @Published var launches: [Launchs] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.launches = []
        self.fetchLaunches(type: .upcoming)
    }
    
    func fetchLaunches(type:LaunchType) {
        self.isLoading = true
        let endpoint: APIEndpoint = type == .upcoming ? .getLaunches : .getPastLaunches
        APIManager.shared.fetch(endpoint, responseType: [Launchs].self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    break
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                self.isLoading = false
                self.errorMessage = nil
                self.launches = response
            }).store(in: &cancellables)
    }
    
    func cancelSubscriptions() {
        cancellables.removeAll()
    }
}
