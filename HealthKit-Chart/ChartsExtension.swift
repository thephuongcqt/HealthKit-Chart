//
//  ChartsExtension.swift
//  HealthKit-Chart
//
//  Created by Nguyen The Phuong on 10/22/18.
//  Copyright © 2018 Nguyen The Phuong. All rights reserved.
//

import Foundation
import Charts

class ChartXAxisFormatter: NSObject {
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?
    
    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}


extension ChartXAxisFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter,
            let referenceTimeInterval = referenceTimeInterval
            else {
                return ""
        }
        
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }    
}
