//
//  UserViewModel.swift
//  SwiftGenericNetworklayer
//
//  Created by Ibukunoluwa Akintobi on 08/06/2024.
//

import Foundation
import Combine
import UIKit

final class UserViewModel {
    let apiClient:ApiProtocol
    
    init(apiClient:ApiProtocol = ApiClient()) {
        self.apiClient = apiClient
    }
    
    private var user : User?
    
    private var cancellables : Set<AnyCancellable> = []
    
    var loadSubject = PassthroughSubject<Bool,ApiError>()
    
    func updateUserProfile(preferredName: String?, photo:UIImage?) {
        let imageData = photo?.jpegData(compressionQuality: 0.5)
        let endpoint = UserEndpoints.updateUser(id: preferredName, file: imageData)
        
        apiClient.combineRequest(endpoint: endpoint, responseModel: User.self)
            .receive(on: DispatchQueue.main)
            .sink {
                [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished :
                    break
                case .failure(let error):
                    self.loadSubject.send(completion: .failure(error))
                }
            } receiveValue: {
                [weak self] user in
                guard let self = self else {return}
                self.user = user
                self.loadSubject.send(true)
            }.store(in: &cancellables)
    }
}
