//
//  ApiClient.swift
//  SwiftGenericNetworklayer
//
//  Created by Ibukunoluwa Akintobi on 06/06/2024.
//

import Foundation
import Combine

final class ApiClient : ApiProtocol {
    var session : URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 300
        return URLSession(configuration: configuration)
    }
    
    func asyncRequest<T:Decodable>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T {
        do {
            let (data, response) = try await session.data(for: endpoint.asURLRequest())
            return try self.manageResponse(data:data, response:response)
        }
        catch let error as ApiError {
            throw error
        }
        catch {
            throw ApiError(errorCode: "ERROR-0", message: "Unknown API error \(error.localizedDescription)")
        }
    }
    
    func combineRequest<T: Decodable>(endpoint: EndpointProvider, responseModel: T.Type) -> AnyPublisher<T, ApiError>{
        do {
            return session
                .dataTaskPublisher(for: try endpoint.asURLRequest())
                .tryMap {
                    output in
                    return try self.manageResponse(data:output.data,response:output.response)
                }
                .mapError {
                    $0 as? ApiError ?? ApiError(errorCode: "ERROR-0", message: "Unknown API error \($0.localizedDescription)")
                }.eraseToAnyPublisher()
        } catch let error as ApiError {
            return AnyPublisher<T,ApiError>(Fail(error: error))
        } catch {
            return AnyPublisher<T,ApiError>(Fail(error: ApiError(
                errorCode: "ERROR-0",
                message: "Unknown API error \(error.localizedDescription)"
            )))
        }
    }
    
    private func manageResponse<T:Decodable>(data:Data, response:URLResponse) throws -> T {
        guard let response = response as? HTTPURLResponse else {
            throw ApiError(
                errorCode:"ERROR-0",
                message: "Invalid HTTP Response"
            )
        }
        switch response.statusCode {
        case 200...299 :
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                print("!!",error)
                throw ApiError(
                    statusCode: response.statusCode,
                    errorCode: "ERROR-0",
                    message:"Unknown backend error"
                )
            }
        default:
            guard let decodedError = try? JSONDecoder().decode(ApiError.self, from: data) else {
                throw ApiError(
                    statusCode: response.statusCode,
                    errorCode: "ERROR-0",
                    message: "Unknown backend error"
                )
            }
            
            if response.statusCode == 403 && decodedError.errorCode == KnownErrors.ErrorCode.expiredToken.rawValue {
                NotificationCenter.default.post(name:.terminateSession , object: self)
            }
            
            throw ApiError(
                    statusCode: response.statusCode,
                    errorCode: decodedError.errorCode,
                    message: decodedError.message
           )
        }
    }
    
    func asyncUpload<T:Decodable>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T {
        guard let uploadData = endpoint.uploadData else {
            throw ApiError(errorCode: "ERROR-0", message: "Invalid upload data")
        }
        do {
            let (data, response) = try await session.upload(for: endpoint.asURLRequest(), from: uploadData)
            return try self.manageResponse(data:data, response:response)
        }
        catch let error as ApiError {
            throw error
        }
        catch {
            throw ApiError(errorCode: "ERROR-0", message: "Unknown API error \(error.localizedDescription)")
        }
    }
    
    func asyncDownload(fileURL: URL) async throws -> URL {
        do {
            let response = try await session.download(from: fileURL)
            return response.0
        } catch {
            let apiError = ApiError(
                errorCode: KnownErrors.ErrorCode.downloadFileError.rawValue,
                message: CustomErrorStrings.downloadFileError
            )
            throw apiError
        }
    }
}



extension Notification.Name {
    static let terminateSession = Notification.Name("terminateSession")
}
