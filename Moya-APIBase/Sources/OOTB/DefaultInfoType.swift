//
//  DefaultInfoType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

// MARK: - DefaultInfoType

public protocol DefaultInfoType: APIInfoType {
    
    func globalHeader() -> [String: String]?
    
    func globalQuery() -> [String: Any]?
    
    func invokeHeader(parameter: Parameter) -> [String: String]?
    
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

extension DefaultInfoType {
    
    public func headers(parameter: Parameter) -> [String : String]? {
        let header = self.invokeHeader(parameter: parameter)
        let globalHeader = self.globalHeader()
        
        if header == nil, globalHeader == nil { return nil }
        if header == nil { return globalHeader }
        if globalHeader == nil { return header }
        
        return globalHeader?.merging(header ?? [:]) { (e1, e2) in e1 }
    }
    
    public func task(parameter: Parameter) -> APITask {
        let query = self.invokeQuery(parameter: parameter)
        let globalQuery = self.globalQuery()
        
        let _query = query ?? [:]
        let _globalQuery = globalQuery ?? [:]
        
        let total = _globalQuery.merging(_query) { (e1, e2) in return e1 }
        
        if total.count > 0 {
            return .requestParameters(parameters: total, encoding: URLEncoding.default)
        }
        
        // 保留原始数据信息
        if query != nil || globalQuery != nil {
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
