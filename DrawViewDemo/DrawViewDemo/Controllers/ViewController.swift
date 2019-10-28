//
//  ViewController.swift
//  DrawViewDemo
//
//  Created by zhuyingqi on 2019/7/16.
//  Copyright © 2019 Ying Qi Zhu. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController, AddButtonItemProtocol {
    var wheel: Int = 0
    func changeWheel() {
        
    }
    func ssss() {
        
    }
    //折线图
    let lineChartView: LineChartView = {
        $0.noDataText = "暂无统计数据" //无数据的时候显示
        $0.chartDescription?.enabled = false //是否显示描述
        $0.scaleXEnabled = false
        $0.scaleYEnabled = false
        $0.legend.enabled = false
        $0.rightAxis.enabled = false
        return $0
    }(LineChartView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "折线图"
        view.backgroundColor = UIColor.white
        addLineChartView()
    }
    
    //配置折线图
    func setLineChartViewData(_ dataPoints: [String], _ values: [Double]) {
        
        lineChartView.delegate = self
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom //x轴的位置
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.granularity = 1.0
        xAxis.valueFormatter = BTCDepthXAxisFormatter()
        /// x线条颜色&宽度
        xAxis.gridColor = UIColor.blue
        xAxis.axisLineColor = UIColor.blue
        xAxis.gridLineWidth = 0.5
        xAxis.gridLineWidth = 0.5
        xAxis.labelCount = 5
        
        var dataEntris: [ChartDataEntry] = []
        for (idx, _) in dataPoints.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(idx), y: values[idx])
            dataEntris.append(dataEntry)
        }
       
        let lineChartDataSet = LineChartDataSet(entries: dataEntris, label: nil)
        //外圈
        lineChartDataSet.setCircleColor(UIColor.lightGray)
        //内圈
        lineChartDataSet.circleHoleColor = UIColor.blue
        //线条显示样式
        lineChartDataSet.colors = [UIColor.orange]
        /// 折现上数值颜色
        lineChartDataSet.valueColors = [UIColor.systemBlue]
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.lineWidth = 1.0
        lineChartDataSet.circleRadius = 4
        lineChartDataSet.circleHoleRadius = 3
        /// 设置折线对象的类型
        lineChartDataSet.mode = .horizontalBezier
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
        //设置x轴样式（X轴上显示出具体的数值）
        let xFormatter = IndexAxisValueFormatter()
        xFormatter.values = dataPoints
        self.lineChartView.animate(xAxisDuration: 0.4)
        
        let yAxis = lineChartView.leftAxis
        yAxis.axisMinimum = 0
        yAxis.axisLineWidth = 0.5
        yAxis.gridLineWidth = 0.5
        yAxis.axisLineColor = UIColor.blue
        yAxis.gridColor = UIColor.blue
        yAxis.labelCount = 5
        yAxis.labelFont = UIFont.systemFont(ofSize: 12)
        yAxis.labelTextColor = UIColor.brown
        yAxis.gridColor = UIColor.blue
        self.lineChartView.animate(yAxisDuration: 0.4)
        
    }
    
    //添加折线图
    func addLineChartView() {
        lineChartView.frame = CGRect(x: 30, y: 300, width: self.view.frame.width - 60, height: 200)
        lineChartView.center.x = self.view.center.x
        self.view.addSubview(lineChartView)
        setLineChartViewData(["老大", "b", "老二", "c", "老三", "d", "老四", "e", "老五", "a",], [1, 10, 11, 19, 30, 80, 15, 2, 8, 67])
    }
}




class BTCDepthXAxisFormatter: NSObject, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let values = ["老大", "b", "老二", "c", "老三", "d", "老四", "e", "老五", "a"]
        return values[Int(value)]
    }
    
}


extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        highlight.
    }
}
