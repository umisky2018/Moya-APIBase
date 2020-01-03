//
//  APIEngineType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public protocol APIEngineType: EngineType {
    
    associatedtype Info = TransitionTarget
    
    associatedtype Target = Result<Response, Error>
}

open class MoyaEngine: APIEngineType {

    private var _provider: Provider<MultiTarget>
    
    public init(provider: Provider<MultiTarget>) {
        self._provider = provider
    }
    
    public func startEngine(info: TransitionTarget, condition: APICondition, completion: @escaping (Result<Response, Error>) -> Void) -> Cancellable {
        return self._provider.request(MultiTarget(info), callbackQueue: condition.dispatchQueue, progress: condition.progressBlock) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let moyaError):
                completion(.failure(moyaError))
            }
        }
    }
}
