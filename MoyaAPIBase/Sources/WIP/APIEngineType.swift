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

    associatedtype Target = Result<Response, MoyaError>
}

extension APIEngineType {
    
    /// 默认启动引擎流程
    public func defaultStartEngine(info: TransitionTarget, condition: APICondition, completion: @escaping (Result<Response, MoyaError>) -> Void) -> Cancellable {
        return condition.inUseProvider.request(info, callbackQueue: condition.dispatchQueue, progress: condition.progressBlock) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let moyaError):
                completion(.failure(moyaError))
            }
        }
    }
}
