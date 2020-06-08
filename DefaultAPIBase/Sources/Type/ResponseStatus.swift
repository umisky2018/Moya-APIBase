//
//  ResponseStatus.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public struct ResponseStatus: RawRepresentable {
    
    public typealias RawValue = Int
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: - Hashable

extension ResponseStatus: Hashable { }

// MARK: - Equatable
 
extension ResponseStatus: Equatable {
    
    public static func == (lhs: ResponseStatus, rhs: ResponseStatus) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension ResponseStatus {
    
    /// 收集的信息有误
    public static let infoError = ResponseStatus(rawValue: rawOffset(target: 1_000))
    
    /// 数据解析失败
    public static let parseFailed = ResponseStatus(rawValue: rawOffset(target: 1_001))
    
    /// Moya 错误
    public static let moyaError = ResponseStatus(rawValue: rawOffset(target: 1_002))
    
    /// 对普通错误的封装
    public static let wrapError = ResponseStatus(rawValue: rawOffset(target: 1_003))
}

extension ResponseStatus {
    
    internal static func rawOffset(target: Int) -> Int {
        return Int(Int16.min) + target
    }
}
