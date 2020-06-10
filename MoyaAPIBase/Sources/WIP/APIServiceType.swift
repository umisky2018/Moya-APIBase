//
//  APIServiceType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public protocol APIServiceType: ServiceType where Info: APIInfoType, Parser: APIParserType, Engine: APIEngineType {
    
    associatedtype ServiceTarget
    
    associatedtype ServiceResult = Result<ServiceTarget, Error>
    
    /// 数据信息  ---- 转换 ---->  引擎燃料
    func engineInfoTransition(info: Info, parameter: Info.Parameter) throws -> Engine.Info
    
    /// 引擎产物 ---- 转换 ---->  解析器原始数据
    func parserOriginTransition(info: Engine.Target) throws -> Parser.Origin
    
    /// 解析器解析结果 ---- 转换 ---->  接口结果
    func serviceResultTransition(info: Parser.Target) throws -> ServiceTarget
}

extension APIServiceType  {
    
    /// 默认激活流程
    public func defaultActivate(parameter: Info.Parameter, condition: APIConfiguration, completion: @escaping (Result<ServiceTarget, Error>) -> Void) -> Cancellable {
        let info = getInfo()
        
        var engineInfo: Engine.Info
        do {
            engineInfo =  try self.engineInfoTransition(info: info, parameter: parameter)
        } catch {
            completion(.failure(error))
            return VoidCancellable()
        }
        
        return getEngine().startEngine(info: engineInfo, condition: condition) { result in
            do {
                let parserOrigin = try self.parserOriginTransition(info: result)
                let parserTarget = try self.getParser().parse(origin: parserOrigin)
                let serviceTarget = try self.serviceResultTransition(info: parserTarget)
                completion(.success(serviceTarget))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
