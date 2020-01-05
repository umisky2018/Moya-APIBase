//
//  DefaultServiceType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public protocol TempServiceType: APIServiceType where Info: DefaultInfoType, Parser: DefaultParserType, Engine: DefaultEngineType, ServiceResult == Result<Parser.Target, ResponseError>  {
    
    associatedtype ServiceResult = Result<Parser.Target, ResponseError>
}

public protocol DefaultServiceType: TempServiceType {
    
    // MARK: - 转换
    
    typealias EngineInfoTransition = (Info, Info.Parameter) throws -> Engine.Info
    
    typealias ParserOriginTransition = (Engine.Target) throws -> Parser.Origin
    
    typealias ServiceResultTransition = (Parser.Target) -> ServiceResult
    
    var engineInfoTransition: EngineInfoTransition { get }
    
    var parserOriginTransition: ParserOriginTransition { get }
    
    var serviceResultTransition: ServiceResultTransition { get }
}

extension DefaultServiceType {

    public func getEngine() -> DefaultEngine {
        return DefaultEngine()
    }
}

extension DefaultServiceType {

    public func activate(parameter: Info.Parameter, completion: @escaping (ServiceResult) -> Void) -> Cancellable {
        return invokeActivate(parameter: parameter, condition: .default(), completion: completion)
    }
}

extension DefaultServiceType where Info.Parameter == Void {

    public func activate(completion: @escaping (ServiceResult) -> Void) -> Cancellable {
        return invokeActivate(parameter: (), condition: .default(), completion: completion)
    }

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

extension DefaultServiceType where Engine.Info == TransitionTarget {
        
    public var engineInfoTransition: EngineInfoTransition {
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

extension DefaultServiceType where Engine.Target == Result<Response, ResponseError> {
    
    public var parserOriginTransition: ParserOriginTransition {
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

extension DefaultServiceType where ServiceResult == Result<Parser.Target, ResponseError> {
    
    public var serviceResultTransition: ServiceResultTransition {
        return Self.defaultServiceResultTransition
    }
    
    internal static func defaultServiceResultTransition(info: Parser.Target) -> ServiceResult {
        return Result.success(info)
    }
}
