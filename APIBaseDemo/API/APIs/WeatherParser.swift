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
    
    typealias Target = WeatherInfoModel2023
}

extension WeatherParser {
    
    func parseTarget(origin: Origin) throws -> Target {
        let jsonDecoder = JSONDecoder()
        let target: Target
        do {
            target = try jsonDecoder.decode(Target.self, from: origin.data)
        } catch {
            // 请求成功，但是数据解析失败。
            throw DemoError(status: .parseFailed, message: "数据解析失败", error: error)
        }
        return target
    }
}
