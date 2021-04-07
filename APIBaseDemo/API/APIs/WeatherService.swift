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

    func getInfo() -> Info {
        return Info()
    }

    func getParser() -> Parser {
        return Parser()
    }
}
