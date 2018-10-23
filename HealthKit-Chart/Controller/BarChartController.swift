//
//  ChartController.swift
//  HealthKit-Chart
//
//  Created by Nguyen The Phuong on 10/19/18.
//  Copyright © 2018 Nguyen The Phuong. All rights reserved.
//

import UIKit
import Charts

class BarChartController: UIViewController{
    
    @IBOutlet weak var barChart: BarChartView!
    var stepsDic: [Date: Double] = [:]
    var sortedArr: [(Date, Double)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let l = barChart.legend
        l.wordWrapEnabled = true
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false

        let rightAxis = barChart.rightAxis
        rightAxis.axisMinimum = 0

        let leftAxis = barChart.leftAxis
        leftAxis.axisMinimum = 0

        let xAxis = barChart.xAxis
        xAxis.labelPosition = .bothSided
        xAxis.axisMinimum = -0.5
        xAxis.granularity = 1
        xAxis.valueFormatter = self
        
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate)!
        HealthKitAssistant.shared.retrieveStepCount(startDate: startDate, endDate: endDate) { (steps, startDate, endDate) in
            self.stepsDic[endDate] = steps
            DispatchQueue.main.async {
                self.barChartUpdate()
            }
        }
    }
    
    func barChartUpdate () {
        sortedArr = stepsDic.sorted(by: { (firstItem, secondItem) -> Bool in
            return firstItem.key < secondItem.key
        })
        
        var count = 0.0
        var entries: [BarChartDataEntry] = []
        
        for (_, value) in sortedArr{
            let entry = BarChartDataEntry(x: count, y: value)
            entries.append(entry)
            count += 1
        }
        
        let dataSet = BarChartDataSet(values: entries, label: "7 days recently")
        let data = BarChartData(dataSets: [dataSet])
        barChart.data = data
        barChart.chartDescription?.text = "Number of steps in day"
        // Color
        dataSet.colors = ChartColorTemplates.vordiplom()
        // Refresh chart with new data
        barChart.notifyDataSetChanged()
    }
}

extension BarChartController: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String{
        let date = sortedArr[Int(value)].0
        let result = dateFormatter.string(from: date)
        return result
    }
}

let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd"
    return dateFormatter
}()
