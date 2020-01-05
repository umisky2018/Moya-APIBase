//
//  APIEngineType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public let defaultProvider = Provider<MultiTarget>()

public protocol APIEngineType: EngineType {
    
    associatedtype Info = TransitionTarget
}

open class MoyaEngine: APIEngineType {

    // Error 没有特定类型
    public typealias Target = Result<Response, Error>
    
    public var provider: Provider<MultiTarget>
    
    required public init(provider: Provider<MultiTarget> = defaultProvider) {
        self.provider = provider
    }
    
    public func startEngine(info: TransitionTarget, condition: APICondition, completion: @escaping (Result<Response, Error>) -> Void) -> Cancellable {
        let provider = condition.stubBehavior ? stubProvider : self.provider
        return provider.request(MultiTarget(info), callbackQueue: condition.dispatchQueue, progress: condition.progressBlock) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let moyaError):
                completion(.failure(ResponseError(status: .moyaError, error: moyaError)))
            }
        }
    }
}
