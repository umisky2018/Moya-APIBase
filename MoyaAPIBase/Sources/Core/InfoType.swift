//
//  InfoType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/1.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

/// 信息收集协议
public protocol InfoType {
    
    /// 参数类型
    associatedtype Parameter
    
    /// 主机地址
    func hostPath() -> URL
    
    /// 相对地址
    func relativePath(parameter: Parameter) -> String
    
    /// 方法
    func method(parameter: Parameter) -> APIMethod
    
    /// 任务
    func task(parameter: Parameter) -> APITask
    
    /// 头信息
    func headers(parameter: Parameter) -> [String: String]?
    
    /// 校验
    func validation() -> ValidationType

    /// 测试数据
    func sampleData() -> Data
}
