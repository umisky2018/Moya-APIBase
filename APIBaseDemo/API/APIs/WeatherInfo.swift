//
//  WeatherInfo.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/10.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase

struct WeatherInfo: DemoInfoType {
    
    typealias Parameter = Void
    
    func relativePath(parameter: Parameter) -> String {
        return "/data/sk/101190408.html"
    }
    
    func method(parameter: Parameter) -> APIMethod {
        return .get
    }
        
    func invokeQuery(parameter: Parameter) -> [String : Any]? {
        return nil
    }
}
