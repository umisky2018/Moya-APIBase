//
//  APIParserType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public protocol APIParserType: ParserType where Origin == Response {
    
    associatedtype Origin = Response
}
