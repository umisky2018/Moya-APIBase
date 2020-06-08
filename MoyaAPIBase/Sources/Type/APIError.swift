//
//  APIError.swift
//  MoyaAPIBase
//
//  Created by umisky on 2020/6/8.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import Moya

public enum APIError: Error {
    
    case moya(MoyaError)
    
    case host
}

extension APIError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .moya(let moyaError):
            return moyaError.localizedDescription
        case .host:
            return "Host Error"
        }
    }
}
