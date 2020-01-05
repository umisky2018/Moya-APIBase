//
//  DefaultParserType.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

// MARK: - DecodableParserType

public protocol DefaultParserType: APIParserType where Target: Decodable, Origin == Response {
    
    // INFO: 需要重复关联一遍，不然编译器无法识别
    associatedtype Origin = Response
}

extension DefaultParserType {

    func parse(origin: Origin) throws -> Target {
        let jsonDecoder = JSONDecoder()
        let target = try jsonDecoder.decode(Target.self, from: origin.data)
        return target
    }
}
