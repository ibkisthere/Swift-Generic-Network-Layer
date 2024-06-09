//
//  MultipartRequest.swift
//  SwiftGenericNetworklayer
//
//  Created by Ibukunoluwa Akintobi on 07/06/2024.
//

import Foundation

struct MultipartRequest {

    private var data =  NSMutableData()

    private let boundary: String = UUID().uuidString
    private let separator: String = "\r\n"

    private var topBoundry: String {
        return "--\(boundary)"
    }

    private var endBoundry: String {
        return "--\(boundary)--"
    }

    private func contentDisposition(_ name: String, fileName: String?) -> String {
        var disposition = "form-data; name=\"\(name)\""
        if let fileName = fileName { disposition += "; filename=\"\(fileName)\"" }
        return "Content-Disposition: " + disposition
    }

    var headerValue: String {
        "multipart/form-data; boundary=\(boundary)"
    }

    var httpBody: Data {
        let bodyData = data
        bodyData.append("--\(boundary)--")
        return bodyData as Data
    }

    var length: UInt64 {
        return UInt64(httpBody.count)
    }

    func append(fileString: String, withName name: String) {
        data.append(topBoundry)
        data.append(separator)
        data.append(contentDisposition(name, fileName: nil))
        data.append(separator)
        data.append(separator)
        data.append(fileString)
        data.append(separator)
    }

    func append(fileData: Data, withName name: String, fileName: String?, mimeType: FileType?) {
        data.append(topBoundry)
        data.append(separator)
        data.append(contentDisposition(name, fileName: fileName))
        data.append(separator)
        if let mimeType = mimeType {
            data.append("Content-Type: \(mimeType.rawValue)" + separator)
        }
        data.append(separator)
        data.append(fileData)
        data.append(separator)
    }

    func append(fileURL: URL, withName name: String) {
        guard let fileData = try? Data(contentsOf: fileURL) else {
            return
        }
        let fileName = fileURL.lastPathComponent
        let pathExtension = fileURL.pathExtension
        let mimeType = 
        
        data.append(topBoundry)
        data.append(separator)
        data.append(contentDisposition(name, fileName: fileName))
        data.append(separator)
        data.append("Content-Type: \(mimeType)" + separator)
        data.append(separator)
        data.append(fileData)
        data.append(separator)
    }
}


