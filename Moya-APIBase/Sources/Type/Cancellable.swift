//
//  Cancellable.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public class VoidCancellable: Cancellable {
    
    public var isCancelled: Bool = false
    
    public init() { }
    
    public func cancel() {
        self.isCancelled = true
    }
}

public class SimpleCancellable: Cancellable {
    
    public var isCancelled: Bool = false
    
    private var _action: (() -> Void)?
    private var _lock = NSRecursiveLock()
    
    public init(_ action: @escaping () -> Void) {
        self._action = action
    }
    
    public func cancel() {
        _lock.lock(); defer { _lock.unlock() }
        guard !isCancelled else { return }
        
        isCancelled = true
        if let action = _action {
            // 取消之后，资源释放
            _action = nil
            action()
        }
    }
}
