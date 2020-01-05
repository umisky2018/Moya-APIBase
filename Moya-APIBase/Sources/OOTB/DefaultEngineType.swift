//
//  DefaultEngineType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public let stubProvider = Provider<MultiTarget>(stubClosure: Provider.delayedStub(2.0))

public protocol DefaultEngineType: APIEngineType {
    
    associatedtype Info = TransitionTarget

    associatedtype Target = Result<Response, ResponseError>
}

public final class DefaultEngine: DefaultEngineType {
    
    public var provider: Provider<MultiTarget>
    
    public init(provider: Provider<MultiTarget> = defaultProvider) {
        self.provider = provider
    }
    
    public func startEngine(info: TransitionTarget, condition: APICondition, completion: @escaping (Result<Response, ResponseError>) -> Void) -> Cancellable {
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
