//
//  Result+Extension.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/11.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

extension Result {
    
    /// 是否成功
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
    
    /// 是否失败
    public var isFailure: Bool {
        switch self {
        case .failure:
            return true
        default:
            return false
        }
    }
    
    /// value 取值
    public var value: Success? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    /// 错误信息
    public var error: Failure? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
