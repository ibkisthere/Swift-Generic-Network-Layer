//
//  MockApiClient.swift
//  SwiftGenericNetworklayer
//
//  Created by Ibukunoluwa Akintobi on 06/06/2024.
//

import Foundation
import Combine

protocol Mockable: AnyObject {
    func loadJSON<T:Decodable>(filename:String, type:T.Type) -> T
    var bundle : Bundle { get }
}


extension Mockable {
    var bundle : Bundle {
        return Bundle(for: type(of: self))
    }
    func loadJSON<T:Decodable>(filename:String, type:T.Type) -> T {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON")
        }; do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode(type, from: data)
            return decodedObject
        } catch {
            fatalError("Failed to decode loaded JSON")
        }
    }
}


class MockApiClient:Mockable, ApiProtocol {
    func asyncRequest<T>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T where T : Decodable {
        return loadJSON(filename: endpoint.mockFile!, type: responseModel.self)
    }
    func combineRequest<T>(endpoint: EndpointProvider, responseModel: T.Type) -> AnyPublisher<T, ApiError> where T : Decodable {
        return Just(loadJSON(filename: endpoint.mockFile!, type: responseModel.self) as T)
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
}
