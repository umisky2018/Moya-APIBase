//
//  DemoInfoType.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/10.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase

protocol DemoInfoType: APIInfoType {
    
    /// 子协议不直接调用 header:，而使用这个函数
    func invokeHeader(parameter: Parameter) -> [String: String]?
    
    /// 子协议不直接调用 task:，使用这个函数
    func invokeQuery(parameter: Parameter) -> [String: Any]?
}

extension DemoInfoType {
        
    func globalQuery() -> [String : Any]? {
        return ["GlobalQueryKey_1": "GlobalQueryValue_1"]
    }
    
    func globalHeader() -> [String : String]? {
        return ["GlobalHeaderKey_1": "GlobalHeaderValue_1"]
    }
    
    func invokeHeader(parameter: Parameter) -> [String: String]? {
        return nil
    }
}

extension DemoInfoType {
    
    func hostPath() -> String {
        return "http://t.weather.sojson.com"
    }
    
    func task(parameter: Parameter) -> APITask {
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
    
    func headers(parameter: Parameter) -> [String : String]? {
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
    
    func validation() -> ValidationType {
        return .none
    }
    
    func sampleData() -> Data {
        return "{}".data(using: .utf8)!
    }
}
