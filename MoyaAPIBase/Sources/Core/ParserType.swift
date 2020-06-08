//
//  ParserType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/1.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

/// 数据解析协议
public protocol ParserType {
    
    /// 原始数据类型
    associatedtype Origin
    
    /// 目标数据类型
    associatedtype Target
    
    /// 解析方法
    func parse(origin: Origin) throws -> Target
}
