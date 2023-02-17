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
        
        WeatherService().activate(parameter: (), condition: .demoConfiguration) { result in
            switch result {
            case .success(let value/* WeatherInfoModel2023 */):
                print("value: \(value)")
            case .failure(let error):
                print("错误描述：\(error.localizedDescription)")
            }
        }
        
//        WeatherService().activateUnwrap(parameter: "101220101") { result in
//            switch result {
//            case .success(let value/* WeatherInfoModel */):
//                print(value)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
}

