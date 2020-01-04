//
//  APIServiceType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public protocol APIServiceType: ServiceType where Info: APIInfoType, Parser: APIParserType, Engine: MoyaEngine {
    
}

extension APIServiceType where Engine.Target == Parser.Origin, ServiceResult == Parser.Target {
    
    public var engineInfoTransition: (Info, Info.Parameter) -> Engine.Info {
        return Self.defaultEngineInfoTransition
    }
    
    public var parserOriginTransition: (Engine.Target) -> Parser.Origin {
        return { o in return o }
    }
    
    public var serviceResultTransition: (Parser.Target) -> ServiceResult {
        return { o in return o }
    }
}

extension APIServiceType {
    
    internal static func defaultEngineInfoTransition(info: Info, parameter: Info.Parameter) -> Engine.Info {
        let url = URL(string: info.hostPath())!
        let path = info.relativePath(parameter: parameter)
        let method = info.method(parameter: parameter)
        let task = info.task(parameter: parameter)
        let headers = info.headers(parameter: parameter)
        let validation = info.validation()
        let sample = info.sampleData()
        return TransitionTarget(baseURL: url, path: path, method: method, sampleData: sample, task: task, headers: headers, validationType: validation)
    }
}
