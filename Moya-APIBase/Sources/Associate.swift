//
//  Associate.swift
//  Moya-APIBase
//
//  Created by umisky on 2020/1/1.
//  Copyright © 2020 umisky. All rights reserved.
//

import Foundation
import Moya

// MARK: - 类型桥接

public typealias APIMethod = Moya.Method
public typealias APITask = Moya.Task
public typealias Response = Moya.Response
public typealias TargetType = Moya.TargetType
public typealias Cancellable = Moya.Cancellable
public typealias ValidationType = Moya.ValidationType
public typealias Provider = Moya.MoyaProvider
public typealias MultiTarget = Moya.MultiTarget
public typealias ProgressBlock = Moya.ProgressBlock
public typealias ProgressResponse = Moya.ProgressResponse
public typealias StubBehavior = Moya.StubBehavior
public typealias StubClosure = Moya.MoyaProvider<MultiTarget>.StubClosure

public typealias ParameterEncoding = Moya.ParameterEncoding
public typealias JSONEncoding = Moya.JSONEncoding
public typealias URLEncoding = Moya.URLEncoding
