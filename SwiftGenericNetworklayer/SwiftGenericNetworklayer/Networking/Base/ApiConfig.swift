//
//  APIConfig.swift
//  SwiftGenericNetworklayer
//
//  Created by Ibukunoluwa Akintobi on 06/06/2024.
//

import Foundation


struct ApiConfig {
    static let shared = ApiConfig();
    
    let baseURL = "https://reqres.in";
    
    let token:String? = "";
}
