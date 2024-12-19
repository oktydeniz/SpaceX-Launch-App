//
//  LaunchViewModel.swift
//  spacex-launches
//
//  Created by oktay on 14.12.2024.
//

import Foundation

import SwiftUI
import Combine

class LaunchViewModel: ObservableObject {
    
    @Published var launch: Launch?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchLaunch(id: String) {
        self.isLoading = true
        APIManager.shared.fetch(.getLauncDetail(id: id), responseType: Launch.self)
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
                self.launch = response
            }).store(in: &cancellables)
    }
    
    func cancelSubscriptions() {
        cancellables.removeAll()
    }
}
