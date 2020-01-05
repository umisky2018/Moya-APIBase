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
    
    associatedtype Target = Decodable
}

extension DefaultParserType {

    func parse(origin: Data) throws -> Target {
        let jsonDecoder = JSONDecoder()
        let target = try jsonDecoder.decode(Target.self, from: origin)
        return target
    }
}
