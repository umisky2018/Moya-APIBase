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
    
    typealias Parameter = String
    
    func relativePath(parameter: String) -> String {
        return "/api/weather/city/\(parameter)"
    }
    
    func method(parameter: String) -> APIMethod {
        return .get
    }
        
    func invokeQuery(parameter: WeatherInfo.Parameter) -> [String : Any]? {
        return nil
    }
}
