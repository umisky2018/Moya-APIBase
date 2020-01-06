//
//  DefaultServiceType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public protocol DefaultServiceType: ServiceType where ServiceResult == Result<Parser.Target, ResponseError>, Info: DefaultInfoType, Parser: DefaultParserType, Engine == DefaultEngine {
        
    associatedtype Engine = DefaultEngine
    
    associatedtype ServiceResult = Result<Parser.Target, ResponseError>
    
    var engineInfoTransition: (Info, Info.Parameter) throws -> Engine.Info { get }
    
    var parserOriginTransition: (Engine.Target) throws -> Parser.Origin { get }
    
    var serviceResultTransition: (Parser.Target) -> ServiceResult { get }
}

extension DefaultServiceType {

    public func getEngine() -> Engine {
        return DefaultEngine()
    }

    @discardableResult
    public func activate(parameter: Info.Parameter, condition: APICondition, completion: @escaping (ServiceResult) -> Void) -> Cancellable {
        return invokeActivate(parameter: parameter, condition: condition, completion: completion)
    }
}

extension DefaultServiceType where Info.Parameter == Void {

    @discardableResult
    public func activate(completion: @escaping (ServiceResult) -> Void) -> Cancellable {
        return invokeActivate(parameter: (), condition: .default(), completion: completion)
    }

    @discardableResult
    public func activate(condition: APICondition, completion: @escaping (ServiceResult) -> Void) -> Cancellable {
        return invokeActivate(parameter: (), condition: condition, completion: completion)
    }
}

extension DefaultServiceType {

    internal func invokeActivate(parameter: Info.Parameter, condition: APICondition, completion: @escaping (ServiceResult) -> Void) -> Cancellable {
        let info = getInfo()
        let engine = getEngine()
        let parser = getParser()

        var engineInfo: Engine.Info
        do {
            engineInfo =  try self.engineInfoTransition(info, parameter)
        } catch {
            completion(.failure(error.asResponseError()))
            return VoidCancellable()
        }

        return engine.startEngine(info: engineInfo, condition: condition) { result in
            do {
                let parserOrigin = try self.parserOriginTransition(result)
                let target = try parser.parse(origin: parserOrigin)
                let success = self.serviceResultTransition(target)
                completion(success)
            } catch {
                completion(.failure(error.asResponseError()))
            }
        }
    }
}

// MARK: - Transition

extension DefaultServiceType {
        
    public var engineInfoTransition: (Info, Info.Parameter) throws -> Engine.Info {
        return Self.defaultEngineInfoTransition
    }
    
    internal static func defaultEngineInfoTransition(info: Info, parameter: Info.Parameter) throws -> Engine.Info {
        let _url = URL(string: info.hostPath())
        guard let url = _url else { throw ResponseError(status: .infoError, message: "Host 地址有误", error: nil) }
        let path = info.relativePath(parameter: parameter)
        let method = info.method(parameter: parameter)
        let task = info.task(parameter: parameter)
        let headers = info.headers(parameter: parameter)
        let validation = info.validation()
        let sample = info.sampleData()
        return TransitionTarget(baseURL: url, path: path, method: method, sampleData: sample, task: task, headers: headers, validationType: validation)
    }
}

extension DefaultServiceType {
    
    public var parserOriginTransition: (Engine.Target) throws -> Parser.Origin {
        return Self.defaultParserOriginTransition
    }

    internal static func defaultParserOriginTransition(info: Engine.Target) throws -> Parser.Origin {
        switch info {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}

extension DefaultServiceType {
    
    public var serviceResultTransition: (Parser.Target) -> ServiceResult {
        return Self.defaultServiceResultTransition
    }
    
    internal static func defaultServiceResultTransition(info: Parser.Target) -> ServiceResult {
        return Result.success(info)
    }
}
