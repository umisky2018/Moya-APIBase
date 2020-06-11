//
//  RequestPlugin.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/11.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import Moya

public class RequestPlugin {
    
    public static var logger = RequestPlugin()
}

extension RequestPlugin: PluginType {
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        output(request: request.request, seprator: true)
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        output(response: result.value)
    }
    
    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        return result
    }
}

extension RequestPlugin {
    
    public func output(request: URLRequest?, seprator: Bool) {
        
        #if DEBUG
        
        print(
            """
            ----------------------------------------------------------------
            | 请求信息 : \(request?.httpMethod ?? "unknown") \(request?.url?.absoluteString ?? "")
            ----------------------------------------------------------------
            """
        )
        
        if let dictionary = request?.allHTTPHeaderFields, dictionary.count > 0 {
            for (key, value) in dictionary {
                print("| \(key) : \(value.removingPercentEncoding ?? "")")
            }
        } else {
            print("| ")
        }
        
        print(
            """
            ----------------------------------------------------------------
            \(String(data: request?.httpBody ?? Data(), encoding: .utf8)?.removingPercentEncoding ?? "")
            """
        )
        if seprator {
            print(
                """
                ----------------------------------------------------------------
                """
            )
        }
        
        #endif
    }
    
    public func output(response: Response?) {
        
//        output(request: response?.request, seprator: false)
        
        #if DEBUG
        
        let _response = response?.response
        
        print(
            """
            ----------------------------------------------------------------
            | 响应信息 : \(_response?.statusCode ?? -1)
            |---------------------------------------------------------------
            """
        )
        
        if let dictionary = _response?.allHeaderFields as? [String: String], dictionary.count > 0 {
            for (key, value) in dictionary {
                print("| \(key) : \(value)")
            }
        } else {
            print("| ")
        }
        
        jsonResponse(data: response?.data ?? Data())
        
        #endif
        
    }
    
    /// 以格式化的字符串输出 JSON 数据
    internal func jsonResponse(data: Data) {
        var formatData: Data = data
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: formatData, options: .allowFragments)
            formatData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        } catch { }
        
        print(
            """
            ----------------------------------------------------------------
            \(String(data: formatData, encoding: .utf8) ?? "")
            ----------------------------------------------------------------
            """
        )
    }
}
