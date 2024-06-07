//
//  SwiftGenericNetworklayerApp.swift
//  SwiftGenericNetworklayer
//
//  Created by Ibukunoluwa Akintobi on 06/06/2024.
//

import Foundation


enum RequestMethod : String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

protocol EndpointProvider {
    var scheme:String { get }
    var baseURL:String { get }
    var path:String { get }
    var method:RequestMethod { get }
    var token:String { get }
    var queryItems:[URLQueryItem]? { get }
    var body:[String:Any]? {get}
    var mockFile :String? { get }
}
