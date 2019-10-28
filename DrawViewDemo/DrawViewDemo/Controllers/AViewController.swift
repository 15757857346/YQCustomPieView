//
//  AViewController.swift
//  DrawViewDemo
//
//  Created by zhuyingqi on 2019/9/12.
//  Copyright © 2019 Ying Qi Zhu. All rights reserved.
//

import UIKit
import WebKit

class AViewController: UIViewController {
    let ScreenWidth: CGFloat = UIScreen.main.bounds.width
    var webView = WKWebView()
    var chartView: CustomPieView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "饼状图"
        loadPieChartView()
    }
    
    func loadPieChartView() {
        chartView = CustomPieView(frame: CGRect(x: 10 , y: view.frame.size.height/2 - 150, width: ScreenWidth - 20, height: 300))
        //数据源
        chartView.segmentDataArray = ["2", "2", "3", "1", "4"]
        //标题，若不传入，则为“其他”
        chartView.segmentTitleArray = ["牙签", "超屌", "痿雷", "🐔强", "骚伦"]
        //颜色数组，若不传入，则为随即色
        chartView.segmentColorArray = [UIColor.red, UIColor.orange, UIColor.green, UIColor.brown]
        //动画时间
        chartView.animateTime = 2
        ///内圆的半径
        chartView.innerCircleR = 32
        //大圆的半径
        chartView.pieRadius = 64
        //整体饼状图的背景色
        chartView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        //圆心位置，此属性会被centerXPosition、centerYPosition覆盖，圆心优先使用centerXPosition、centerYPosition
        chartView.centerType = .PieCenterTypeMiddleLeft
        //是否动画
        chartView.needAnimation = true
        //动画类型，全部只有一个动画；各个部分都有动画
        chartView.type = .PieAnimationTypeTogether
        //圆心，相对于饼状图的位置
        chartView.centerXPosition = 25 + chartView.pieRadius
        //文本的行间距
        chartView.textSpace = 15
        //文本距离右侧的间距
        chartView.textRightSpace = 37
        //点击圆饼后的偏移量
        chartView.clickOffsetSpace = 10
        //点击触发的block，index与数据源对应
        chartView.clickPieView { (index) in
            print("点击\(index)")
        }
        chartView.showCustomViewInSuperView(superView: self.view)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        chartView.hideText = true
//        chartView.pieRadius = 100
//        chartView.centerXPosition = 0
//        chartView.centerYPosition = 0
//        chartView.centerType = .PieCenterTypeCenter
//        chartView.updatePieView()
    }
}

