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
        return ""
    }

    func method(parameter: Parameter) -> APIMethod {
        return .get
    }

    func query(parameter: Parameter) -> [String : Any]? {
        return nil
    }
}
