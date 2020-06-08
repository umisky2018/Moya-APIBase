//
//  DefaultServiceType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase

public protocol DefaultServiceType: APIServiceType where Info: DefaultInfoType, Parser: DefaultParserType, Engine == DefaultEngine, ServiceResult == Parser.Target, ServiceError == ResponseError {
    
    associatedtype Engine = DefaultEngine
    
    associatedtype ServiceError = ResponseError
}

extension DefaultServiceType {

    public func getEngine() -> Engine {
        return DefaultEngine()
    }

    @discardableResult
    public func activate(parameter: Info.Parameter, condition: APICondition, completion: @escaping (Result<Parser.Target, ResponseError>) -> Void) -> Cancellable {
        return invokeActivate(parameter: parameter, condition: condition, completion: completion)
    }
}

extension DefaultServiceType where Info.Parameter == Void {

    @discardableResult
    public func activate(completion: @escaping (Result<ServiceResult, ServiceError>) -> Void) -> Cancellable {
        return invokeActivate(parameter: (), condition: .default(), completion: completion)
    }

    @discardableResult
    public func activate(condition: APICondition, completion: @escaping (Result<ServiceResult, ServiceError>) -> Void) -> Cancellable {
        return invokeActivate(parameter: (), condition: condition, completion: completion)
    }
}

extension DefaultServiceType {

    internal func invokeActivate(parameter: Info.Parameter, condition: APICondition, completion: @escaping (Result<ServiceResult, ServiceError>) -> Void) -> Cancellable {
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
                let success = self.serviceResultTransition(info: target)
                completion(success)
            } catch {
                completion(.failure(error.asResponseError()))
            }
        }
    }
}

// MARK: - Transition

extension DefaultServiceType {
        
    public func parserOriginTransition(info: Engine.Target) throws -> Parser.Origin {
        switch info {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    public func serviceResultTransition(info: Parser.Target) -> Result<ServiceResult, ServiceError> {
        return .success(info)
    }
}
