//
//  TransitionTarget.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/4.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

public struct TransitionTarget {
    
    public var baseURL: URL
    
    public var path: String
    
    public var method: APIMethod
    
    public var sampleData: Data
    
    public var task: APITask
    
    public var headers: [String : String]?
    
    public var validationType: ValidationType

    public init(baseURL: URL, path: String, method: APIMethod, sampleData: Data, task: APITask, headers: [String : String]?, validationType: ValidationType) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.sampleData = sampleData
        self.task = task
        self.headers = headers
        self.validationType = validationType
    }
}

extension TransitionTarget: TargetType { }
