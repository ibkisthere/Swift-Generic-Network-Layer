//
//  UserViewController.swift
//  SwiftGenericNetworklayer
//
//  Created by Ibukunoluwa Akintobi on 08/06/2024.
//

import UIKit
import Combine


class UserViewController: UIViewController {
    let viewModel = UserViewModel()
    private var cancellables : Set<AnyCancellable> = []
    
    private var isPhotoChanged = false
    
    @IBAction func saveAction(_ sender:UIButton) {
        viewModel.updateUserProfile(
            preferredName: preferredNameTextField.inputTextField.formattedText,
            //unimplemented
            photo: isPhotoChanged ? userProfileImageView.image : nil
        )
        viewModel.loadSubject.sink {
            [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    //unimplemented
                    self.showRequestError(error: error, action: nil)
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                //unimplemented
                self.updateDataIfNeeded()
                NotificationCenter.default.post(name: .userUpdate, object: self, userInfo: ["user": self.viewModel.user])
                self.coordinator.popEditProfile()
            }
            .store(in: &cancellables)
    }
}
