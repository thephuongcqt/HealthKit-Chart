//
//  ChartController.swift
//  HealthKit-Chart
//
//  Created by Nguyen The Phuong on 10/19/18.
//  Copyright © 2018 Nguyen The Phuong. All rights reserved.
//

import UIKit
import HealthKit

class ChartController: UIViewController {
    
    let healthStore = HKHealthStore()
    
    var stepsDic: [Date: Double]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -70, to: endDate)!
        HealthKitAssistant.shared.retrieveStepCount(startDate: startDate, endDate: endDate) { (steps, startDate, endDate) in
            self.stepsDic?[endDate] = steps
        }
    }

    
    
}
