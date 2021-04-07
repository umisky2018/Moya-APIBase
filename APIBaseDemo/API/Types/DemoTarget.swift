//
//  DemoTarget.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/11.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

struct StatusTarget: Decodable {
    
    var status: Int
    
    var message: String?
}

struct DefaultTarget<Payload>: Decodable where Payload: Decodable {
    
    var status: Int
    
    var message: String?
    
    var data: Payload
}

// MARK: - Parser

struct InternalStatusTarget: Decodable {
    
    var status: Int?
    
    var message: String?
}

/// 单解析 Payload 的模型
struct InternalDefaultTarget<Payload>: Decodable where Payload: Decodable {
    
    var data: Payload
}
