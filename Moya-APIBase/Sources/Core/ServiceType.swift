//
//  ServiceType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/1.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public protocol ServiceType {
    
    associatedtype Info: InfoType
    
    associatedtype Parser: ParserType
    
    associatedtype Engine: EngineType
    
    associatedtype ServiceResult
    
    associatedtype ServiceError: Error
    
    /// 获取信息
    func getInfo() -> Info
    
    /// 获取解析器
    func getParser() -> Parser
    
    /// 获取引擎
    func getEngine() -> Engine
    
    /// 激活请求流程
    func activate(parameter: Info.Parameter, condition: APICondition, completion: @escaping (Result<ServiceResult, ServiceError>) -> Void) -> Cancellable
}
