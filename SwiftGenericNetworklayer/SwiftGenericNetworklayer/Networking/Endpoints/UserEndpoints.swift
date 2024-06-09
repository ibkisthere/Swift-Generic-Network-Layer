//
//  UserEndpoints.swift
//  SwiftGenericNetworklayer
//
//  Created by Ibukunoluwa Akintobi on 06/06/2024.
//

import Foundation


struct Password: Encodable {
    let password: String
}

enum UserEndpoints: EndpointProvider {
    case createPassword(password: Password)
    case updatePassword(id: String)
    case createUser(id: String?, file:Data?)
    case updateUser(id:String?, file:Data?)

    var path: String {
        switch self {
        case .createUser:
            return "/api/v2/user/create"
        case .updateUser:
            return "/api/v2/user/update"
        case .createPassword:
            return "/api/v2/user"
        case .updatePassword:
            return "/api/v2/user"
        }
    }

    var method: RequestMethod {
        switch self {
        case .createUser:
            return .post
        case .updateUser:
            return .put
        case .createPassword:
            return .post
        case .updatePassword:
            return .post
        }
        
    }

        var queryItems: [URLQueryItem]? {
            return nil
        }
    
       var multipart: MultipartRequest? {
           switch self {
           case .updateUser(let userName, let file):
               let multipart = MultipartRequest()
               if let preferredName = userName {
                   if let stringData = preferredName.data(using: .utf8) {
                       multipart.append(fileData: stringData,withName: "preferredName",fileName:nil, mimeType:.plainText)
                   }
               }
               if let file = file {
                   multipart.append(fileData: file, withName: "profilePicture", fileName: "profilePicture.jpg", mimeType: .jpeg)
               }
          
               return multipart
        
             default : return nil
           }
       }
  /// skipping other bits

    var body: [String: Any]? {
        switch self {
        case .createPassword(let password):
            return nil
        case .updatePassword(let password):
            return nil
        case .createUser(let user, let file):
            return nil
        case .updateUser(let user, let file):
            return nil
        }
    }
    var mockFile: String? {
        switch self {
        case .createPassword:
            return "_createPasswordMockResponse"
        case .updatePassword:
            return "_updatePasswordMockResponse"
        case .createUser:
            return "_createUserMockResponse"
        case .updateUser:
            return "_updateUserMockResponse"
        }
    }
}
