//
//  ApiError.swift
//  SwiftGenericNetworklayer
//
//  Created by Ibukunoluwa Akintobi on 06/06/2024.
//

import Foundation

struct ApiError: Error {
    var statusCode:Int!
    let errorCode:String
    var message :String
    
    init(statusCode: Int = 0, errorCode:String, message:String) {
        self.statusCode = statusCode
        self.errorCode = errorCode
        self.message = message
    }
    
    var errorCodeNumber:String {
        let numberString = errorCode.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return numberString
    }
    
    private enum CodingKeys:String,CodingKey {
        case errorCode
        case message
    }
}

extension ApiError : Decodable {
    init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errorCode = try container.decode(String.self, forKey: .errorCode)
        message = try container.decode(String.self, forKey: .message)
    }
}

enum KnownErrors {
    enum ErrorCode: String {
        case expiredToken = "EXPIRED_TOKEN"
        case invalidCredentials = "INVALID_CREDENTIALS"
        case networkError = "NETWORK_ERROR"
        case downloadFileError = "DOWNLOAD_ERROR"
    }
}

enum CustomError: String, Error {
    case expiredToken = "EXPIRED_TOKEN"
    case invalidCredentials = "INVALID_CREDENTIALS"
    case networkError = "NETWORK_ERROR"
    case downloadFileError = "DOWNLOAD_ERROR"
    case unknownError = "UNKNOWN_ERROR"
}

struct CustomErrorStrings {
    static let expiredToken = NSLocalizedString("The token has expired. Please log in again.", comment: "")
    static let invalidCredentials = NSLocalizedString("The credentials provided are invalid. Please check your username and password.", comment: "")
    static let networkError = NSLocalizedString("A network error occurred. Please check your connection and try again.", comment: "")
    static let downloadFileError = NSLocalizedString("An error occurred while downloading the file. Please try again.", comment: "")
    static let unknownError = NSLocalizedString("An unknown error occurred. Please try again.", comment: "")
    
    static func localizedDescription(for error: CustomError) -> String {
        switch error {
        case .expiredToken:
            return CustomErrorStrings.expiredToken
        case .invalidCredentials:
            return CustomErrorStrings.invalidCredentials
        case .networkError:
            return CustomErrorStrings.networkError
        case .downloadFileError:
            return CustomErrorStrings.downloadFileError
        case .unknownError:
            return CustomErrorStrings.unknownError
        }
    }
}
