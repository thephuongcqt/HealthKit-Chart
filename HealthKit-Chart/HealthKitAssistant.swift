//
//  HealthKitSetupAssistant.swift
//  HealthKit-Chart
//
//  Created by Nguyen The Phuong on 10/19/18.
//  Copyright © 2018 Nguyen The Phuong. All rights reserved.
//

import HealthKit

class HealthKitAssistant {
    
    static let shared = HealthKitAssistant()
    let healthStore = HKHealthStore()
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        
        //1. Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        //2. Prepare the data types that will interact with HealthKit
        guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let stepsQuantityType = HKObjectType.quantityType(forIdentifier: .stepCount),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
                
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }        
        //3. Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex,
                                                        activeEnergy,
                                                        height,
                                                        bodyMass,
                                                        HKObjectType.workoutType()]
        
        let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                       bloodType,
                                                       biologicalSex,
                                                       bodyMassIndex,
                                                       height,
                                                       bodyMass,
                                                       stepsQuantityType,
                                                       HKObjectType.workoutType()]
        //4. Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead) { (success, error) in
                                                completion(success, error)
        }
    }
    
    func getActiveEnergy(completion: @escaping (Double) -> Void){
        let activityEnergyType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: activityEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            guard let result = result, let sum = result.sumQuantity() else{
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.kilocalorie()))
        }
        
        healthStore.execute(query)
    }
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        healthStore.execute(query)
    }
    
    func saveBodyInfo(height: Double, weight: Double, bmi: Double, date: Date){
        let bmiType = HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!
        let heightType = HKObjectType.quantityType(forIdentifier: .height)!
        let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        
        let bmiQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: bmi)
        let heightQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: height)
        let bodyMassQuantity = HKQuantity(unit: HKUnit.gramUnit(with: .kilo), doubleValue: weight)
        
        let bmiSample = HKQuantitySample(type: bmiType, quantity: bmiQuantity, start: date, end: date)
        let heightSample = HKQuantitySample(type: heightType, quantity: heightQuantity, start: date, end: date)
        let bodyMassSample = HKQuantitySample(type: bodyMassType, quantity: bodyMassQuantity, start: date, end: date)

        healthStore.save(bmiSample) { (success, errror) in
            print("abc")
        }
        healthStore.save(heightSample) { (success, errror) in
            print("abc")
        }
        healthStore.save(bodyMassSample) { (success, errror) in
            print("abc")
        }
    }
}


extension HKBiologicalSex {
    var stringRepresentation: String {
        switch self {
        case .notSet: return "Unknown"
        case .female: return "Female"
        case .male: return "Male"
        case .other: return "Other"
        }
    }
}

extension HKBloodType {
    
    var stringRepresentation: String {
        switch self {
        case .notSet: return "Unknown"
        case .aPositive: return "A+"
        case .aNegative: return "A-"
        case .bPositive: return "B+"
        case .bNegative: return "B-"
        case .abPositive: return "AB+"
        case .abNegative: return "AB-"
        case .oPositive: return "O+"
        case .oNegative: return "O-"
        }
    }
}
