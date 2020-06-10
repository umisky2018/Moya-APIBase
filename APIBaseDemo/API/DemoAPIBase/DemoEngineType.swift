//
//  DemoEngineType.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/10.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase

protocol DemoEngineType: APIEngineType {
    
}

struct DemoEngin: DemoEngineType {
    
    func startEngine(info: TransitionTarget, condition: APIConfiguration, completion: @escaping (Result<Response, MoyaError>) -> Void) -> Cancellable {
        self.defaultStartEngine(info: info, condition: condition, completion: completion)
    }
}
