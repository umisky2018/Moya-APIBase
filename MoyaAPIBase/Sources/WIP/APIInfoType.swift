//
//  APIInfoType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public protocol APIInfoType: InfoType {
    
    /// 全局 Header
    func globalHeader() -> [String: String]?
    
    /// 全局 Query
    func globalQuery() -> [String: Any]?
}

public extension APIInfoType {
    
    func globalHeader() -> [String: String]? {
        return nil
    }
    
    func globalQuery() -> [String: Any]? {
        return nil
    }
}
