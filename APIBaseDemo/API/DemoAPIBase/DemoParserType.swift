//
//  DefaultParserType.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/10.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase

protocol DemoParserType: APIParserType where Target: Decodable {
    
    func parseStatus(origin: Origin) throws -> StatusTarget

    func parseResult(origin: Origin) throws -> DefaultTarget<Target>
}

extension DemoParserType {
    
    func parseTarget(origin: Origin) throws -> Target {
        let result = try self.optionalParser(origin: origin)
        return result.data
    }

    func parseStatus(origin: Origin) throws -> StatusTarget {
        let result = try self.statusValidation(origin: origin)
        return StatusTarget(status: result.status, message: result.message)
    }

    func parseResult(origin: Origin) throws -> DefaultTarget<Target> {
        let result = try self.optionalParser(origin: origin)
        return result
    }
}

// MARK: - Internal

extension DemoParserType {
    
    @discardableResult
    fileprivate func statusValidation(origin: Origin) throws -> StatusTarget {
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
        return StatusTarget(status: statusCode, message: target.message)
    }
    
    fileprivate func optionalParser(origin: Origin) throws -> DefaultTarget<Target> {
        // 先判断响应的状态，能继续往下就是成功了
        let status = try statusValidation(origin: origin)
        
        let jsonDecoder = JSONDecoder()
        let target: InternalDefaultTarget<Target>
        do {
            target = try jsonDecoder.decode(InternalDefaultTarget<Target>.self, from: origin.data)
        } catch {
            // 请求成功，但是数据解析失败。
            throw DemoError(status: .parseFailed, message: "数据解析失败", error: error)
        }
        return DefaultTarget(status: status.status, message: status.message, data: target.data)
    }
}
