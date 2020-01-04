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
    
    func getInfo() -> Info
    
    func getParser() -> Parser
    
    func getEngine() -> Engine
    
    func activate(parameter: Info.Parameter, condition: APICondition, completion: @escaping (ServiceResult) -> Void) -> Cancellable
    
    // MARK: - 转换
    
    typealias EngineInfoTransition = (Info, Info.Parameter) -> Engine.Info
    
    typealias ParserOriginTransition = (Engine.Target) -> Parser.Origin
    
    typealias ServiceResultTransition = (Parser.Target) -> ServiceResult
    
    var engineInfoTransition: EngineInfoTransition { get }
    
    var parserOriginTransition: ParserOriginTransition { get }
    
    var serviceResultTransition: ServiceResultTransition { get }
}

extension ServiceType {
    
    public func activate(parameter: Info.Parameter, completion: @escaping (ServiceResult) -> Void) -> Cancellable {
        return _activate(parameter: parameter, condition: .default(), completion: completion)
    }
}

extension ServiceType where Info.Parameter == Void {
    
    public func activate(completion: @escaping (ServiceResult) -> Void) -> Cancellable {
        return _activate(parameter: (), condition: .default(), completion: completion)
    }
    
    public func activate(condition: APICondition, completion: @escaping (ServiceResult) -> Void) -> Cancellable {
        return _activate(parameter: (), condition: condition, completion: completion)
    }
}

extension ServiceType {
    
    internal func _activate(parameter: Info.Parameter, condition: APICondition, completion: @escaping (ServiceResult) -> Void) -> Cancellable {
        let info = getInfo()
        let engine = getEngine()
        let parser = getParser()
        
        let engineInfo = self.engineInfoTransition(info, parameter)
        
        return engine.startEngine(info: engineInfo, condition: condition) { result in
            let parserOrigin = self.parserOriginTransition(result)
            let parserTarget = parser.parse(origin: parserOrigin)
            let serviceResult = self.serviceResultTransition(parserTarget)
            completion(serviceResult)
        }
    }
}
