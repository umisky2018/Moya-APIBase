//
//  DemoTarget.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/11.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation

struct DefaultTarget<Payload>: Decodable where Payload: Decodable {
    
    var status: Int
    
    var message: String?
    
    var data: Payload
}

struct OptionalTarget<Payload>: Decodable where Payload: Decodable {
    
    var status: Int
    
    var message: String?
    
    var data: Payload?
}

// MARK: - Parser codable


struct InternalStatusTarget: Decodable {
    
    var status: Int?
    
    var message: String?
}

struct InternalOptionalTarget<Payload>: Decodable where Payload: Decodable {
    
    var status: Int
    
    var message: String?
    
    var data: Payload?
}

struct InternalDefaultTarget<Payload>: Decodable where Payload: Decodable {
    
    var status: Int
    
    var data: Payload

    var message: String?
}
