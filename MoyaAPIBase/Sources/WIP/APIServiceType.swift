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
    
    /// 解析器解析结果 ---- 转换 ---->  接口结果
    func serviceResultTransition(info: Parser.Target) throws -> ServiceResult
}
