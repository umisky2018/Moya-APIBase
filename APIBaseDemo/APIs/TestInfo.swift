//
//  TestInfo.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/8.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import MoyaAPIBase
import DefaultAPIBase

struct TestInfo: DefaultInfoType {    

    typealias Parameter = Void
    
    func hostPath() -> String {
        return "https://juejin.im"
    }

    func relativePath(parameter: Parameter) -> String {
        return "/post/5e7b2348e51d4526eb227c82"
    }

    func method(parameter: Parameter) -> APIMethod {
        return .get
    }

    func invokeQuery(parameter: Void) -> [String : Any]? {
        return nil
    }

    func invokeHeader(parameter: Void) -> [String : String]? {
        return nil
    }
}
