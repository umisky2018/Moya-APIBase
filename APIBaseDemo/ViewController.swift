//
//  ViewController.swift
//  APIBaseDemo
//
//  Created by umisky on 2020/6/8.
//  Copyright © 2020 umisky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherService().activateNormal(parameter: "101220101") { result in
            switch result {
            case .success(let value/* DefaultTarget<WeatherInfoModel> */):
                print(value.message ?? "请求成功")
            case .failure(let error):
                print("错误描述：\(error.localizedDescription)")
            }
        }
        
        WeatherService().activateUnwrap(parameter: "101220101") { result in
            switch result {
            case .success(let value/* WeatherInfoModel */):
                print(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

