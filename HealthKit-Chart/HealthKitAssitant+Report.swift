//
//  HealthKitAssitant+Report.swift
//  HealthKit-Chart
//
//  Created by Nguyen The Phuong on 10/22/18.
//  Copyright © 2018 Nguyen The Phuong. All rights reserved.
//

import Foundation
import HealthKit

extension HealthKitAssistant{
    func retrieveStepCount(startDate: Date, endDate: Date, completion: @escaping (_ stepRetrieved: Double, _ startDate: Date, _ endDate: Date) -> Void) {
        //   Define the Step Quantity Type
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        //   Get the start of the day
        let date = Date()
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let newDate = cal.startOfDay(for: date)
        //  Set the Predicates & Interval
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        var interval = DateComponents()
        interval.day = 1
        //  Perform the Query
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: newDate as Date, intervalComponents:interval)
        
        query.initialResultsHandler = { query, results, error in
            if error != nil {
                //  Something went Wrong
                return
            }
            
            if let myResults = results{
                myResults.enumerateStatistics(from: startDate, to: endDate) {
                    statistics, stop in
                    
                    if let quantity = statistics.sumQuantity() {
                        let startDate = statistics.startDate
                        let endDate = statistics.endDate
                        let steps = quantity.doubleValue(for: HKUnit.count())
                        completion(steps, startDate, endDate)
                    }
                }
            }            
        }
        healthStore.execute(query)
    }
}
