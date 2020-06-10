//
//  DemoParserType.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/10.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase

protocol DemoParserType: APIParserType where Target: Decodable {
    
}

extension DemoParserType {
    
    func parse(origin: Origin) throws -> Target {
        let jsonDecoder = JSONDecoder()
        let target = try jsonDecoder.decode(Target.self, from: origin.data)
        return target
    }
}
