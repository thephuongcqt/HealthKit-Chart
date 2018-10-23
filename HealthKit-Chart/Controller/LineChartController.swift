//
//  LineChartController.swift
//  HealthKit-Chart
//
//  Created by Nguyen The Phuong on 10/23/18.
//  Copyright © 2018 Nguyen The Phuong. All rights reserved.
//

import UIKit
import Charts

class LineChartController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    var stepsDic: [Date: Double] = [:]
    
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
        var count = 0.0
        let entries = stepsDic.map { (key, value) -> ChartDataEntry in
            count += 1
            return ChartDataEntry(x: count, y: value, icon: nil)
        }
        
        let set1 = LineChartDataSet(values: entries, label: "Data Set 1")
        set1.drawIconsEnabled = false
        set1.lineDashLengths = [5, 2.5]
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(.black)
        set1.setCircleColor(.black)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
    }
}
