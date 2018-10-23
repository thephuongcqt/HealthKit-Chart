//
//  CombinedChartController.swift
//  HealthKit-Chart
//
//  Created by Nguyen The Phuong on 10/22/18.
//  Copyright © 2018 Nguyen The Phuong. All rights reserved.
//

import UIKit
import Charts

class PieChartController: UIViewController {
    
    var stepsDic: [Date: Double] = [:]
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate)!
        HealthKitAssistant.shared.retrieveStepCount(startDate: startDate, endDate: endDate) { (steps, startDate, endDate) in
            self.stepsDic[endDate] = steps
            DispatchQueue.main.async {
                self.setupChart()
            }
        }
    }
    
    func setupChart(){
        let entries = stepsDic.map { (key, value) -> PieChartDataEntry in
            return PieChartDataEntry(value: value, label: dateFormatter.string(from: key), icon: nil)
        }
        let set = PieChartDataSet(values: entries, label: "Pie Chart")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        set.valueLinePart1OffsetPercentage = 0.8
        set.valueLinePart1Length = 0.2
        set.valueLinePart2Length = 0.4
        //set.xValuePosition = .outsideSlice
        set.yValuePosition = .outsideSlice
        
        let data = PieChartData(dataSet: set)
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " steps"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        pieChartView.data = data
        pieChartView.highlightValue(nil)
    }
}
