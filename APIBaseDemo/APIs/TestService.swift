//
//  TestService.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/8.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase
import DefaultAPIBase

struct TestService: DefaultServiceType {
            
    typealias ServiceTarget = Parser.Target

    typealias Info = TestInfo
    
    typealias Parser = TestParser
    
    func getInfo() -> Info {
        return Info()
    }
    
    func getParser() -> Parser {
        return Parser()
    }
}
