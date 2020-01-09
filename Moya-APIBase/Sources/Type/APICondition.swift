//
//  APICondition.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/2.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

open class APICondition {
        
    public var dispatchQueue: DispatchQueue = DispatchQueue.main
    
    public var progressBlock: (ProgressResponse) -> Void = { _ in }
        
    public var stubBehavior: Bool = false

    public init() { }
    
    public func specify(_ dispatchQueue: DispatchQueue) -> Self {
        self.dispatchQueue = dispatchQueue
        return self
    }

    public func specify(_ progressBlock: @escaping ((ProgressResponse) -> Void)) -> Self {
        self.progressBlock = progressBlock
        return self
    }
    
    public func specify(_ stubBehavior: Bool) -> Self {
        self.stubBehavior = stubBehavior
        return self
    }
}

extension APICondition {
    
    /// 默认
    public static func `default`() -> APICondition {
        return APICondition()
    }
    
    /// 主线程
    public static func main() -> APICondition {
        return APICondition().specify(.main)
    }
}
