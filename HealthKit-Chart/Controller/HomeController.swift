//
//  ViewController.swift
//  HealthKit-Chart
//
//  Created by Nguyen The Phuong on 10/19/18.
//  Copyright © 2018 Nguyen The Phuong. All rights reserved.
//

import UIKit

class HomeController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()        
    }
    
    private func authorizeHealthKit() {
        HealthKitAssistant.shared.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            print("HealthKit Successfully Authorized.")
        }
    }
}

