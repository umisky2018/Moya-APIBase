//
//  APIEngineType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public protocol APIEngineType: EngineType where Info == TransitionTarget, Target == Result<Response, MoyaError> {

    associatedtype Info = TransitionTarget

    associatedtype Target = Result<Response, MoyaError>
    
    /// 启动引擎
    func startEngine(info: Info, condition: APIConfiguration, completion: @escaping (Target) -> Void) -> Cancellable
}

extension APIEngineType {
    
    public func startEngine(info: Info, condition: APIConfiguration, completion: @escaping (Target) -> Void) -> Cancellable {
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

public struct MoyaEngin: APIEngineType { }
