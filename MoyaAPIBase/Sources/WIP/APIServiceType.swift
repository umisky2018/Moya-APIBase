//
//  APIServiceType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public protocol APIServiceType: ServiceType where Info: APIInfoType, Parser: APIParserType, Engine: APIEngineType, ServiceResult == Result<Parser.Target, Error> {
    
    associatedtype ServiceResult = Result<Parser.Target, Error>
    
    /// 数据信息  ---- 转换 ---->  引擎燃料
    func engineInfoTransition(info: Info, parameter: Info.Parameter) throws -> Engine.Info
    
    /// 引擎产物 ---- 转换 ---->  解析器原始数据
    func parserOriginTransition(info: Engine.Target) throws -> Parser.Origin
}

extension APIServiceType {
    
    public func defaultActivate(parameter: Info.Parameter, condition: APIConfiguration, completion: @escaping (ServiceResult) -> Void) -> Cancellable {
        let info = getInfo()
        
        var enginInfo: Engine.Info
        do {
            enginInfo = try self.engineInfoTransition(info: info, parameter: parameter)
        } catch {
            completion(.failure(error))
            return VoidCancellable()
        }
        
        return getEngine().startEngine(info: enginInfo, condition: condition) { result in
            // 全局队列解析
            DispatchQueue.global(qos: .background).async {
                do {
                    let parserOrigin = try self.parserOriginTransition(info: result)
                    let parserTarget = try self.getParser().parse(origin: parserOrigin)
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
