//
//  DefaultInfoType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import Moya_APIBase

// MARK: - DefaultInfoType

public protocol DefaultInfoType: APIInfoType {
    
    /// 全局 Header
    func globalHeader() -> [String: String]?
    
    /// 全局 Query
    func globalQuery() -> [String: Any]?
    
    /// 子协议不直接调用 header:，而使用这个函数
    func invokeHeader(parameter: Parameter) -> [String: String]?
    
    /// 子协议不直接调用 task:，使用这个函数
    func invokeQuery(parameter: Parameter) -> [String: Any]?
}

extension DefaultInfoType {
    
    func globalHeader() -> [String: String]? {
        return nil
    }
    
    func globalQuery() -> [String: Any]? {
        return nil
    }
    
    func invokeHeader(parameter: Parameter) -> [String: String]? {
        return nil
    }
    
    func invokeQuery(parameter: Parameter) -> [String: Any]? {
        return nil
    }
}

// MARK: - 默认功能

extension DefaultInfoType {
    
    public func headers(parameter: Parameter) -> [String : String]? {
        let header = self.invokeHeader(parameter: parameter)
        let globalHeader = self.globalHeader()
        
        if let _header = header, let _globalheader = globalHeader {
            /// 自定义 header 优先级最高
            return _globalheader.merging(_header) { _, e2 in return e2 }
        }
        
        if header == nil { return globalHeader }
        if globalHeader == nil { return header }
        return nil
    }
    
    public func task(parameter: Parameter) -> APITask {
        let query = self.invokeQuery(parameter: parameter)
        let globalQuery = self.globalQuery()
        
        var totalQuery: [String: Any] = [:]
        
        if let _globalQuery = globalQuery {
            totalQuery.merge(_globalQuery) { _ , e2 in return  e2 }
        }
        
        if let _query = query {
            totalQuery.merge(_query) { _ , e2 in return  e2 }
        }
                
        if totalQuery.count > 0 {
            return .requestParameters(parameters: totalQuery, encoding: URLEncoding.default)
        } else if query != nil || globalQuery != nil {
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        } else {
            return .requestPlain
        }
    }
    
    public func validation() -> ValidationType {
        return .none
    }
    
    public func sampleData() -> Data {
        return "{}".data(using: .utf8)!
    }
}
