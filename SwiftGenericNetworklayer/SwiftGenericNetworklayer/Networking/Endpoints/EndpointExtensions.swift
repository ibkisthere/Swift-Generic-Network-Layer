//
//  EndpointProvider1.swift
//  SwiftGenericNetworklayer
//
//  Created by Ibukunoluwa Akintobi on 06/06/2024.
//

import Foundation

extension EndpointProvider {
    var scheme :String {
        return "https"
    }
    
    var baseURL : String {
        return ApiConfig.shared.baseURL
    }
    
    var token:String {
//        return ApiConfig.shared.token?.value ?? ""
          return ApiConfig.shared.token ?? ""
    }
    
    var multipart: MultipartRequest? {
        return nil
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = baseURL
        urlComponents.path = path
        if let queryItems  = queryItems {
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else {
            throw ApiError(errorCode: "ERROR-0", message: "URL error")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("true", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("true", forHTTPHeaderField: "X-Use-Cache")
        
        if !token.isEmpty {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body = body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                throw ApiError(errorCode:"ERROR-0", message: "Error encoding http body")
            }
        }
        if let multipart = multipart {
            urlRequest.setValue(multipart.headerValue, forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("\(multipart.length)", forHTTPHeaderField: "Content-Length")
            urlRequest.httpBody = multipart.httpBody
        }
        
        return urlRequest
    }
    
    var uploadData : Data? {
        return nil 
    }
}
