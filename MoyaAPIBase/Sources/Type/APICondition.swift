//
//  APICondition.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/2.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

private let DefaultProvider = Provider<TransitionTarget>()
private let StubProvider = Provider<TransitionTarget>(stubClosure: Provider.delayedStub(2.0))

open class APICondition {
    
    public var dispatchQueue: DispatchQueue = DispatchQueue.main
    
    public var progressBlock: (ProgressResponse) -> Void = { _ in }
    
    public var stubBehavior: Bool = false
    
    public var stubProvider: Provider<TransitionTarget> = StubProvider
    
    public var provider: Provider<TransitionTarget> = DefaultProvider
    
    public init() { }
    
    @discardableResult
    public func specify(_ dispatchQueue: DispatchQueue) -> Self {
        self.dispatchQueue = dispatchQueue
        return self
    }
    
    @discardableResult
    public func specify(_ progressBlock: @escaping ((ProgressResponse) -> Void)) -> Self {
        self.progressBlock = progressBlock
        return self
    }
    
    @discardableResult
    public func specify(_ stubBehavior: Bool) -> Self {
        self.stubBehavior = stubBehavior
        return self
    }
    
    @discardableResult
    public func specify(stubProvider: Provider<TransitionTarget>) -> Self {
        self.stubProvider = stubProvider
        return self
    }
    
    @discardableResult
    public func specify(provider: Provider<TransitionTarget>) -> Self {
        self.provider = provider
        return self
    }
}

extension APICondition {
    
    /// 默认
    public static var `default`: APICondition {
        return APICondition()
    }
    
    /// 桩数据
    public static var stub: APICondition {
        return APICondition().specify(true)
    }
}

extension APICondition {
    
    /// 当前的 provider
    open var inUseProvider: Provider<TransitionTarget> {
        return self.stubBehavior ? self.stubProvider : self.provider
    }
}
