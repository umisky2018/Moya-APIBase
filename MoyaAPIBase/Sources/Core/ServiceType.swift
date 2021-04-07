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
        
    /// 获取信息
    func getInfo() -> Info
    
    /// 获取解析器
    func getParser() -> Parser
    
    /// 获取引擎
    func getEngine() -> Engine
}
