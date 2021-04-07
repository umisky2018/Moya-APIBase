//
//  EngineType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/1.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

/// 引擎协议
public protocol EngineType {
    
    /// 启动引擎的燃料
    associatedtype Info
    
    /// 引擎产物
    associatedtype Target
}
