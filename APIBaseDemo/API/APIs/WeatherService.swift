//
//  WeatherService.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/10.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase

struct WeatherService: DemoServiceType {    
    
    typealias Info = WeatherInfo
    
    typealias Parser = WeatherParser
    
    typealias ServiceTarget = WeatherInfoModel
    
    func getInfo() -> Info {
        return Info()
    }
    
    func getParser() -> Parser {
        return Parser()
    }
    
    func serviceResultTransition(info: Parser.Target) throws -> ServiceTarget {
        if let _data = info.data {
            return _data
        }
        throw DemoError(status: .dataNotFound)
    }
}
