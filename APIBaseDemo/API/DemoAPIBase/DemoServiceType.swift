//
//  DemoServiceType.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/10.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase

let loggerProvider = Provider<TransitionTarget>()

extension APIConfiguration {
    static let demoConfiguration = APIConfiguration.default.specify(provider: loggerProvider)
}

protocol DemoServiceType: APIServiceType where Info: DemoInfoType, Parser: DemoParserType {
    
    func activateTargetRequest(parameter: Info.Parameter, condition: APIConfiguration, completion: @escaping (Result<Parser.Target, DemoError>) -> Void) -> Cancellable
}

extension DemoServiceType {
    
    /// 获取目标内容
    @discardableResult
    func activateTargetRequest(parameter: Info.Parameter, condition: APIConfiguration = .demoConfiguration, completion: @escaping (Result<Parser.Target, DemoError>) -> Void) -> Cancellable {
        _activate(parameter: parameter, condition: condition) { result in
            var rst: Result<Parser.Target, DemoError>
            switch result {
            case .success(let response):
                do {
                    let target = try self.getParser().parseTarget(origin: response)
                    rst = .success(target)
                } catch {
                    rst = .failure(error.asDemoError())
                }
            case .failure(let error):
                rst = .failure(error)
            }
            DispatchQueue.main.async { completion(rst) }
        }
    }
    
    /// 获取状态
    @discardableResult
    func activateStatusRequest(parameter: Info.Parameter, condition: APIConfiguration = .demoConfiguration, completion: @escaping (Result<StatusTarget, DemoError>) -> Void) -> Cancellable {
        return _activate(parameter: parameter, condition: condition) { result in
            var rst: Result<StatusTarget, DemoError>
            switch result {
            case .success(let response):
                do {
                    let target = try self.getParser().parseStatus(origin: response)
                    rst = .success(target)
                } catch {
                    rst = .failure(error.asDemoError())
                }
            case .failure(let error):
                rst = .failure(error)
            }
            DispatchQueue.main.async { completion(rst) }
        }
    }
    
    /// 获取完整结果
    @discardableResult
    func activateResultRequest(parameter: Info.Parameter, condition: APIConfiguration = .demoConfiguration, completion: @escaping (Result<DefaultTarget<Parser.Target>, DemoError>) -> Void) -> Cancellable {
        return _activate(parameter: parameter, condition: condition) { result in
            var rst: Result<DefaultTarget<Parser.Target>, DemoError>
            switch result {
            case .success(let response):
                do {
                    let target = try self.getParser().parseResult(origin: response)
                    rst = .success(target)
                } catch {
                    rst = .failure(error.asDemoError())
                }
            case .failure(let error):
                rst = .failure(error)
            }
            DispatchQueue.main.async { completion(rst) }
        }
    }
    
    /// ⚠️ 回调是异步的
    private func _activate(parameter: Info.Parameter, condition: APIConfiguration, completion: @escaping (Result<Response, DemoError>) -> Void) -> Cancellable {
        let info = getInfo()
        var enginInfo: Engine.Info
        
        do {
            enginInfo = try self.engineInfoTransition(info: info, parameter: parameter)
        } catch {
            completion(.failure(error.asDemoError()))
            return VoidCancellable()
        }
        
        return getEngine().startEngine(info: enginInfo, condition: condition) { result in
            DispatchQueue.global(qos: .background).async {
                do {
                    let parserOrigin = try self.parserOriginTransition(info: result)
                    completion(.success(parserOrigin))
                } catch {
                    completion(.failure(error.asDemoError()))
                }
            }
        }
    }
}
