//
//  MultipartRequestExtensions.swift
//  SwiftGenericNetworklayer
//
//  Created by Ibukunoluwa Akintobi on 07/06/2024.
//

import Foundation
import UniformTypeIdentifiers
import MobileCoreServices


extension MultipartRequest {
    private func mimeType(for pathExtension:String) -> String {
        if #available(iOS 14,macOS 11, tvOS 14, watchOS 7, *) {
            return UTType(filenameExtension: pathExtension)?.preferredMIMEType ?? "application/octet-stream"
        } else {
            if let id = UTTypeCreatePreferredIdentifierForTag(
                kUTTagClassFilenameExtension,
                pathExtension as CFString,
                nil
            )?.takeRetainedValue(),
               let contentType = UTTypeCopyPreferredTagWithClass(id, kUTTagClassMIMEType)?.takeRetainedValue() {
                return contentType as String
            }
            return "application/octet-stream"
        }
    }
}


extension NSMutableData {
    func append(_ string:String, encoding:String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            self.append(data)
        }
    }
}

enum FileType: String {
    /// image/webm, audio/ogg, audio/mpeg, audio/mp4, video/mpeg, video/quicktime, video/webm
    /// application/msword, application/excel, application/powerpoint, application/x-zip
    case jpeg = "image/jpeg"
    case png = "image/png"
    case gif = "image/gif"
    case tiff = "image/tiff"
    case bmp = "image/bmp"
    case quickTime = "video/quicktime"
    case mov = "video/mov"
    case mp4 = "video/mp4"
    case pdf = "application/pdf"
    case vnd = "application/vnd"
    case plainText = "text/plain"
    case anyBinary = "application/octet-stream"
}
