//
//  DemoServiceType.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/10.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase

let loggerProvider = Provider<TransitionTarget>(plugins: [RequestPlugin.logger])

extension APIConfiguration {
    static let defaultAPIConfiguration = APIConfiguration.default.specify(provider: loggerProvider)
}

protocol DemoServiceType: APIServiceType where Engine == DemoEngin {
    
    associatedtype Engin = DemoEngin
}

extension DemoServiceType {
    
    func getEngine() -> Engine {
        return DemoEngin()
    }
    
    @discardableResult
    func activate(parameter: Info.Parameter, condition: APIConfiguration = .defaultAPIConfiguration, completion: @escaping (Result<Parser.Target, Error>) -> Void) -> Cancellable {
        return defaultActivate(parameter: parameter, condition: condition, completion: completion)
    }
    
    @discardableResult
    func activateNormal(parameter: Info.Parameter, condition: APIConfiguration = .defaultAPIConfiguration, completion: @escaping (Result<Parser.Target, DemoError>) -> Void) -> Cancellable {
        return activate(parameter: parameter, condition: condition) { result in
            switch result {
            case .success(let target):
                completion(.success(target))
            case .failure(let error):
                completion(.failure(error.asDemoError()))
            }
        }
    }
}

// MARK: - Convenient

extension DemoServiceType where Info.Parameter == Void {
    
    @discardableResult
    func activateNormal(condition: APIConfiguration = .defaultAPIConfiguration, completion: @escaping (Result<Parser.Target, DemoError>) -> Void) -> Cancellable {
        return defaultActivate(parameter: (), condition: condition) { result in
            switch result {
            case .success(let target):
                completion(.success(target))
            case .failure(let error):
                completion(.failure(error.asDemoError()))
            }
        }
    }
}

extension DemoServiceType where Parser: DemoParserType, Parser.Target == DefaultTarget<Parser.Payload> {
    
    @discardableResult
    func activateUnwrap(parameter: Info.Parameter, condition: APIConfiguration = .defaultAPIConfiguration, completion: @escaping (Result<Parser.Payload, DemoError>) -> Void) -> Cancellable {
        return activateNormal(parameter: parameter, condition: condition) { result in
            switch result {
            case .success(let value):
                completion(.success(value.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension DemoServiceType where Parser: DemoParserType, Parser.Target == OptionalTarget<Parser.Payload> {
    
    @discardableResult
    func activateUnwrap(parameter: Info.Parameter, condition: APIConfiguration = .defaultAPIConfiguration, completion: @escaping (Result<Parser.Payload?, DemoError>) -> Void) -> Cancellable {
        return activateNormal(parameter: parameter, condition: condition) { result in
            switch result {
            case .success(let value):
                completion(.success(value.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Transition

extension DemoServiceType {
    
    /// 数据信息  ---- 转换 ---->  引擎燃料
    func engineInfoTransition(info: Info, parameter: Info.Parameter) throws -> Engine.Info {
        let _url = URL(string: info.hostPath())
        guard let url = _url else { throw DemoError(status: .hostError, message: nil, error: nil) }
        let path = info.relativePath(parameter: parameter)
        let method = info.method(parameter: parameter)
        let task = info.task(parameter: parameter)
        let headers = info.headers(parameter: parameter)
        let validation = info.validation()
        let sample = info.sampleData()
        return TransitionTarget(baseURL: url, path: path, method: method, sampleData: sample, task: task, headers: headers, validationType: validation)
    }
    
    /// 引擎产物 ---- 转换 ---->  解析器原始数据
    func parserOriginTransition(info: Engine.Target) throws -> Parser.Origin {
        return try info.get()
    }
}
