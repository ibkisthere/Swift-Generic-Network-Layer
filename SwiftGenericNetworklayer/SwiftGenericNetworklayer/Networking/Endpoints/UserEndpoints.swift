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
    case createUser(id: String)
    case updateUser(id:String)

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
        switch self {
        default:
            return nil
        }
    }
  /// skipping other bits

    var body: [String: Any]? {
        switch self {
        case .createPassword(let password):
            return password.toDictionary
        case .updatePassword(let password):
            return password.toDictionary
        case .createUser(let user):
            return user.toDictionary
        case .updateUser(let password):
            return password.toDictionary        }
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
