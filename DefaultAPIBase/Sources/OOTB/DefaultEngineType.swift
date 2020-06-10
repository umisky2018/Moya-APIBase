//
//  DefaultEngineType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase

public protocol DefaultEngineType: APIEngineType {
    
    associatedtype Info = TransitionTarget

    associatedtype Target = Result<Response, ResponseError>
}

public final class DefaultEngine: DefaultEngineType {
    
    public var provider: Provider<TransitionTarget>
    
    public init(provider: Provider<TransitionTarget> = defaultProvider) {
        self.provider = provider
    }
    
    public func startEngine(info: TransitionTarget, condition: APIConfiguration, completion: @escaping (Result<Response, ResponseError>) -> Void) -> Cancellable {
        let provider = condition.stubBehavior ? stubProvider : provider
        return provider.request(info, callbackQueue: condition.dispatchQueue, progress: condition.progressBlock) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let moyaError):
                completion(.failure(ResponseError(status: .moyaError, error: moyaError)))
            }
        }
    }
}
