//
//  DefaultServiceType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase

public protocol DefaultServiceType: APIServiceType where Info: DefaultInfoType, Parser: DefaultParserType, Engine == DefaultEngine, ServiceResult == Result<ServiceTarget, Error> {
    
    associatedtype Engine = DefaultEngine
    
    associatedtype ServiceTarget
    
    associatedtype ServiceResult = Result<ServiceTarget, Error>
}

extension DefaultServiceType {

    public func getEngine() -> Engine {
        return DefaultEngine()
    }
    
    func activate(parameter: Info.Parameter, condition: APICondition, completion: @escaping (ServiceResult) -> Void) -> Cancellable {
        return invokeActivate(parameter: parameter, condition: condition, completion: completion)
    }
}

extension DefaultServiceType {

    internal func invokeActivate(parameter: Info.Parameter, condition: APICondition, completion: @escaping (Result<ServiceTarget, Error>) -> Void) -> Cancellable {
        let info = getInfo()

        var engineInfo: Engine.Info
        do {
            engineInfo =  try self.engineInfoTransition(info: info, parameter: parameter)
        } catch {
            completion(.failure(error.asResponseError()))
            return VoidCancellable()
        }

        return getEngine().startEngine(info: engineInfo, condition: condition) { result in
            do {
                let parserOrigin = try self.parserOriginTransition(info: result)
                let target = try self.getParser().parse(origin: parserOrigin)
                let success = try self.serviceResultTransition(info: target)
                completion(success)
            } catch {
                completion(.failure(error.asResponseError()))
            }
        }
    }
}

// MARK: - Convinent function

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

// MARK: - Transition

extension DefaultServiceType {
    
    public func engineInfoTransition(info: Info, parameter: Info.Parameter) throws -> Engine.Info {
        let _url = URL(string: info.hostPath())
        guard let url = _url else { throw ResponseError(status: .hostError, message: "Host 错误", error: nil) }
        let path = info.relativePath(parameter: parameter)
        let method = info.method(parameter: parameter)
        let task = info.task(parameter: parameter)
        let headers = info.headers(parameter: parameter)
        let validation = info.validation()
        let sample = info.sampleData()
        return TransitionTarget(baseURL: url, path: path, method: method, sampleData: sample, task: task, headers: headers, validationType: validation)
    }
    
    public func parserOriginTransition(info: Engine.Target) throws -> Parser.Origin {
        switch info {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}

extension DefaultServiceType where Parser.Target == ServiceTarget {
    
    public func serviceResultTransition(info: Parser.Target) throws -> ServiceResult {
        return .success(info)
    }
}
