//
//  ProfileData.swift
//  HealthKit-Chart
//
//  Created by Nguyen The Phuong on 10/19/18.
//  Copyright © 2018 Nguyen The Phuong. All rights reserved.
//

import Foundation
import HealthKit

class ProfileData{
    static func getUserProfile() ->
        (age: Int?, biologicalSex: HKBiologicalSex?, bloodType: HKBloodType?){
        let healthKitStore = HKHealthStore()
        
            let birthdayComponents = try? healthKitStore.dateOfBirthComponents()
            let biologicalSex = try? healthKitStore.biologicalSex()
            let bloodType = try? healthKitStore.bloodType()
            
            
            let today = Date()
            let calendar = Calendar.current
            let todayDateComponents = calendar.dateComponents([.year],
                                                                  from: today)
            let thisYear = todayDateComponents.year
            let age: Int? = {
                if let year = thisYear, let birthday = birthdayComponents?.year{
                    return year - birthday
                } else {
                    return nil
                }
            }()
            
            let unwrappedBiologicalSex = biologicalSex?.biologicalSex
            let unwrappedBloodType = bloodType?.bloodType
            
            return (age, unwrappedBiologicalSex, unwrappedBloodType)
    }
}
