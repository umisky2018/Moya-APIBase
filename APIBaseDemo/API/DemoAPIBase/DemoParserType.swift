//
//  DemoParserType.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/10.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase

protocol DemoParserType: APIParserType where Target: Decodable, Payload: Decodable {
    
    associatedtype Payload
}

extension DemoParserType where Target == DefaultTarget<Payload> {

    func parse(origin: Origin) throws -> Target {
        let internalTarget = try defautParser(origin: origin)
        return DefaultTarget(status: internalTarget.status, message: internalTarget.message, data: internalTarget.data)
    }
}

extension DemoParserType where Target == OptionalTarget<Payload> {

    func parse(origin: Origin) throws -> Target {
        let internalTarget = try optionalParser(origin: origin)
        return OptionalTarget(status: internalTarget.status, message: internalTarget.message, data: internalTarget.data)
    }
}

// MARK: - Internal

extension DemoParserType {
    
    @discardableResult
    func statusValidation(origin: Origin) throws -> InternalStatusTarget {
        let jsonDecoder = JSONDecoder()
        var target: InternalStatusTarget
        do {
            target = try jsonDecoder.decode(InternalStatusTarget.self, from: origin.data)
        } catch {
            throw DemoError(status: .parseFailed, message: "数据解析失败", error: error)
        }
        guard let statusCode = target.status else { throw DemoError(status: .statusNotFound) }
        let status = DemoStatus(rawValue: statusCode)
        if !status.isSuccess {
            throw DemoError(status: status, message: target.message, error: nil)
        }
        return target
    }
    
    func optionalParser(origin: Origin) throws -> InternalOptionalTarget<Payload> {
        try statusValidation(origin: origin)
        let jsonDecoder = JSONDecoder()
        let target: InternalOptionalTarget<Payload>
        do {
            target = try jsonDecoder.decode(InternalOptionalTarget<Payload>.self, from: origin.data)
        } catch {
            throw DemoError(status: .parseFailed, message: "数据解析失败", error: error)
        }
        return target
    }
    
    func defautParser(origin: Origin) throws -> InternalDefaultTarget<Payload> {
        let target = try optionalParser(origin: origin)
        guard let payload = target.data else { throw DemoError(status: .dataNotFound) }
        return InternalDefaultTarget(status: target.status, data: payload, message: target.message)
    }
}
