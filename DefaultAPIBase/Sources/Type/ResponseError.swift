//
//  ResponseError.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public struct ResponseError {
    
    public let status: ResponseStatus
    
    public let message: String?
    
    public let underlyingError: Error?
    
    public init(status: ResponseStatus, message: String? = nil, error: Error? = nil) {
        self.status = status
        self.message = message
        self.underlyingError = error
    }
}

extension ResponseError: Error { }

extension Error {
    
    public func asResponseError() -> ResponseError {
        if let rsp = self as? ResponseError {
            return rsp
        } else {
            return ResponseError(status: .wrapError, message: nil, error: self)
        }
    }
}
