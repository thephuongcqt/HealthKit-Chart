//
//  WorkoutController.swift
//  HealthKit-Chart
//
//  Created by Nguyen The Phuong on 10/19/18.
//  Copyright © 2018 Nguyen The Phuong. All rights reserved.
//

import UIKit
import Eureka

class WorkoutController: FormViewController {
    var height: Double?
    var weight: Double?
    var bmi: Double = 0.0
    var rowBMI: LabelRow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Body Measurements")
            <<< DecimalRow(){ row in
                row.tag = "rowHeight"
                row.title = "Height"
                row.placeholder = "Enter your height (meters)"
                }.onChange({ (row) in
                    self.height = row.value
                    self.updateBMI()
                })
            <<< DecimalRow(){
                $0.tag = "rowWeight"
                $0.title = "Weight"
                $0.placeholder = "Enter your weight (kg)"
                }.onChange({ (row) in
                    self.weight = row.value
                    self.updateBMI()
                })
            +++ Section("Result")
            <<< LabelRow(){
                $0.tag = "rowBMI"
                $0.title = "BMI"
            }
            <<< ButtonRow() {
                $0.tag = "buttonUpdate"
                $0.title = "Update Data"
                }.onCellSelection({ (cell, row) in
                    self.buttonUpdateTapped()
                })
        
        rowBMI = form.rowBy(tag: "rowBMI")
        // Do any additional setup after loading the view.
    }
    
    func updateBMI(){
        if let height = height, let weight = weight, height != 0{
            bmi = weight/(height * height)
            DispatchQueue.main.async {
                self.rowBMI?.title = "BMI: \(self.bmi)"
                self.rowBMI?.updateCell()
            }
            print(bmi)
        }
    }
    
    func buttonUpdateTapped(){
        if let height = height, let weight = weight{
            HealthKitAssistant.shared.saveBodyInfo(height: height, weight: weight, bmi: bmi, date: Date())
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
