//
//  WeatherParser.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/10.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase

struct WeatherParser: DemoParserType {
        
    typealias Target = WeatherModel
}

extension WeatherParser {
    
    func parse(origin: Response) throws -> WeatherModel {
        let jsonDecoder = JSONDecoder()
        let target = try jsonDecoder.decode(Target.self, from: origin.data)
        
        guard let status = target.status else { throw DemoError(status: .statusNotFound) }
        if status != 200 {
            throw DemoError(status: DemoStatus(rawValue: status), message: target.message, error: nil)
        }
        
        return target
    }
}
