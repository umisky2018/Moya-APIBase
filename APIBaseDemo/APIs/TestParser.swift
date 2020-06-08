//
//  TestParser.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/8.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase
import DefaultAPIBase

struct TestParser: DefaultParserType {
        
    typealias Target = String
    
    func parse(origin: Response) throws -> String {
        return try origin.mapString()
    }
}
