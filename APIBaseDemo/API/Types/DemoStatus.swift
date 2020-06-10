//
//  DemoStatus.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/10.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public struct DemoStatus: RawRepresentable {
    
    public typealias RawValue = Int
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: - Hashable

extension DemoStatus: Hashable { }

// MARK: - Equatable

extension DemoStatus: Equatable {
    
    public static func == (lhs: DemoStatus, rhs: DemoStatus) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

// MARK: - 本地定义

extension DemoStatus {
    
    /// 收集的信息有误
    public static let infoError = DemoStatus(rawValue: 1_000)
    
    /// 数据解析失败
    public static let parseFailed = DemoStatus(rawValue: 1_001)
    
    /// Moya 错误
    public static let moyaError = DemoStatus(rawValue: 1_002)
    
    /// 普通错误的封装
    public static let wrapError = DemoStatus(rawValue: 1_003)
    
    /// Host 错误
    public static let hostError = DemoStatus(rawValue: 1_004)
    
    /// 找不到 status code
    public static let statusNotFound = DemoStatus(rawValue: 1_005)
    
    /// 找不到必要的 data
    public static let dataNotFound = DemoStatus(rawValue: 1_006)
}

// MARK: - 服务端定义

extension DemoStatus {
    
    /// 状态码错误
    public static let statusError = DemoStatus(rawValue: 404)
}
