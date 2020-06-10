//
//  DemoError.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/10.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase

public struct DemoError {
    
    public let status: DemoStatus
    
    public let message: String?
    
    public let underlyingError: Error?
    
    public init(status: DemoStatus, message: String? = nil, error: Error? = nil) {
        self.status = status
        self.message = message
        self.underlyingError = error
    }
}

extension DemoError: Error { }

extension Error {
    
    public func asDemoError() -> DemoError {
        if let rsp = self as? DemoError {
            return rsp
        }
        if let rsp = self as? MoyaError {
            return DemoError(status: .moyaError, message: nil, error: rsp)
        }
        return DemoError(status: .wrapError, message: nil, error: self)
    }
}
