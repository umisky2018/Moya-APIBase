//
//  APIServiceType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public protocol APIServiceType: ServiceType where Info: APIInfoType, Parser: APIParserType, Engine: APIEngineType {
        
    /// 数据信息  ---- 转换 ---->  引擎燃料
    func engineInfoTransition(info: Info, parameter: Info.Parameter) throws -> Engine.Info
    
    /// 引擎产物 ---- 转换 ---->  解析器原始数据
    func parserOriginTransition(info: Engine.Target) throws -> Parser.Origin

    /// 激活请求流程
    func activate(parameter: Info.Parameter, condition: APIConfiguration, completion: @escaping (Result<Parser.Target, Error>) -> Void) -> Cancellable
}

public extension APIServiceType {
    
    func getEngine() -> MoyaEngin {
        return MoyaEngin()
    }
    
    /// 默认激活策略
    @discardableResult
    func activate(parameter: Info.Parameter, condition: APIConfiguration = .default, completion: @escaping (Result<Parser.Target, Error>) -> Void) -> Cancellable {
        let info = getInfo()
        var enginInfo: Engine.Info
        
        do {
            enginInfo = try self.engineInfoTransition(info: info, parameter: parameter)
        } catch {
            completion(.failure(error))
            return VoidCancellable()
        }
        
        return getEngine().startEngine(info: enginInfo, condition: condition) { result in
            DispatchQueue.global(qos: .background).async {
                do {
                    let parserOrigin = try self.parserOriginTransition(info: result)
                    let parserTarget = try self.getParser().parseTarget(origin: parserOrigin)
                    DispatchQueue.main.async {
                        completion(.success(parserTarget))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

// MARK: - Transition

extension APIServiceType {
    
    /// 数据信息  ---- 转换 ---->  引擎燃料
    public func engineInfoTransition(info: Info, parameter: Info.Parameter) throws -> Engine.Info {
        let url = info.hostPath()
        let path = info.relativePath(parameter: parameter)
        let method = info.method(parameter: parameter)
        let task = info.task(parameter: parameter)
        let headers = info.headers(parameter: parameter)
        let validation = info.validation()
        let sample = info.sampleData()
        return TransitionTarget(baseURL: url, path: path, method: method, sampleData: sample, task: task, headers: headers, validationType: validation)
    }
    
    /// 引擎产物 ---- 转换 ---->  解析器原始数据
    public func parserOriginTransition(info: Engine.Target) throws -> Parser.Origin {
        return try info.get()
    }
}
