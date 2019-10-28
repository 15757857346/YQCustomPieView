//
//  DrawView.swift
//  DrawViewDemo
//
//  Created by zhuyingqi on 2019/7/16.
//  Copyright © 2019 Ying Qi Zhu. All rights reserved.
//

import UIKit

@IBDesignable class DrawView: UIView {
    var runLabel: UILabel!
    @IBInspectable var labelTitle: String!
    @IBInspectable var labelColor: UIColor!
    override init(frame: CGRect) {
        super.init(frame: frame)
        addUISubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addUISubviews()
    }
    func addUISubviews() {
        labelTitle = "一起扯扯"
        labelColor = UIColor.black
        runLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 180, height: 80))
        runLabel.textColor = labelColor
        runLabel.text = labelTitle
        addSubview(runLabel)
    }
    override func layoutSubviews() {
        runLabel.textColor = labelColor
        runLabel.text      = labelTitle
    }
}


@IBDesignable class SView: UIView {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(red: 1, green: 0, blue: 0, alpha: 1)
        context.setLineWidth(5)
        context.strokePath()
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: 0, y: 100))
        context.addLine(to: CGPoint(x: 50, y: 200))
        context.strokePath()
    }
}
