//
//  EventsViewModel.swift
//  SwiftGenericNetworklayer
//
//  Created by Ibukunoluwa Akintobi on 07/06/2024.
//

import Foundation
import Combine

final class EventsViewModel: ObservableObject {
    let apiClient:ApiProtocol
    
    //Dependency injection
    init(apiClient: ApiProtocol = ApiClient()) {
        self.apiClient = apiClient
    }
    
    @Published var userEvents:[Event] = []
    @Published var eventError:ApiError?
    private var cancellables : Set<AnyCancellable> = []
    
    @MainActor
    func getAsyncEvents() async {
        let endpoint = EventsEndpoints.getEvents
        Task.init {
            do {
                let events = try await apiClient.asyncRequest(endpoint: endpoint, responseModel:[Event].self)
                userEvents = events
            }
        }
    }
    
    func getCombinedEvents() {
        let endpoint = EventsEndpoints.getEvents
        apiClient.combineRequest(endpoint: endpoint, responseModel: [Event].self)
            .receive(on: DispatchQueue.main)
            .sink {
                [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.eventError = error
                }
            } receiveValue: {  [weak self] events in
                guard let self = self else { return }
                self.userEvents = events
            }.store(in: &cancellables)
    }
}
