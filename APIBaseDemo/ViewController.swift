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
        
        
        TestService().activate { result in
            switch result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
        // Do any additional setup after loading the view.
    }


}

