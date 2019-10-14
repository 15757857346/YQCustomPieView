//
//  CustomShapeLayer.swift
//  DrawViewDemo
//
//  Created by zhuyingqi on 2019/10/12.
//  Copyright © 2019 Ying Qi Zhu. All rights reserved.
//

import UIKit
import QuartzCore

class CustomShapeLayer: CAShapeLayer {
    /// 起始弧度
    public var startAngle: CGFloat = 0
    /// 结束弧度
    public var endAngle: CGFloat = 0
    ///  圆饼半径
    public var radius: CGFloat = 0
    /// 点击偏移量
    public var clickOffset: CGFloat = 0
    /// 是否点击
    public var isSelected: Bool = false
    {
        didSet {
            var newCenterPoint = centerPoint
            let offset: CGFloat = preferGetUserSetValue(userValue: clickOffset, defaultValue: 15)
            if isOneSection {
                dealOneSectionWithSelected(isSelected, offset: offset)
                return
            }
            if isSelected {
                //center 往外围移动一点 使用cosf跟sinf函数
                let cosf_value: CGFloat = CGFloat(cosf(Float((startAngle + endAngle) / 2))) * offset
                let sinf_value: CGFloat = CGFloat(sinf(Float((startAngle + endAngle) / 2))) * offset
                newCenterPoint = CGPoint(x: centerPoint.x + cosf_value, y: centerPoint.y + sinf_value)
            }
            let path = UIBezierPath()
            path.move(to: newCenterPoint)
            path.addArc(withCenter: newCenterPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addArc(withCenter: newCenterPoint, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
            path.close()
            self.path = path.cgPath
            
            // 添加动画
            let animation = CABasicAnimation()
            animation.keyPath = "path"
            animation.toValue = path
            animation.duration = 0.35
            self.add(animation, forKey: nil)
        }
    }
    /// 是否只有一个模块，多个模块的动画与单个模块的动画不一样
    public var isOneSection: Bool = false
    /// 圆饼layer的圆心
    public var centerPoint: CGPoint = CGPoint(x: 0, y: 0)
    /// 内圆半径
    public var innerRadius: CGFloat = 0
    /// 内圆颜色
    public var innerColor: UIColor = UIColor.white
    
    // MARK: - 绘制饼饼
    private func dealOneSectionWithSelected(_ isSelected: Bool, offset: CGFloat) {
        // 创建一个path
        let originPath = UIBezierPath()
        // 起始中心改一下噻
        originPath.move(to: centerPoint)
        originPath.addArc(withCenter: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        originPath.addArc(withCenter: centerPoint, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
        originPath.close()
        
        /// 再整一个path
        let path = UIBezierPath()
        path.move(to: centerPoint)
        path.addArc(withCenter: centerPoint, radius: radius + offset, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addArc(withCenter: centerPoint, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
        path.close()
        
        if !isSelected {
            self.path = originPath.cgPath
            /// 整个动画
            let animation = CABasicAnimation()
            animation.keyPath = "path"
            animation.fromValue = path
            animation.toValue = originPath
            animation.duration = 0.35
            self.add(animation, forKey: nil)
        } else {
            self.path = path.cgPath
            let animation = CABasicAnimation()
            animation.fromValue = originPath
            animation.toValue = path
            animation.keyPath = "path"
            animation.duration = 0.35
            self.add(animation, forKey: nil)
        }
        
    }
    
    // MARK:- Tools
    private func preferGetUserSetValue(userValue: CGFloat, defaultValue: CGFloat) -> CGFloat {
        if userValue > 0 {
            return userValue
        } else {
            return defaultValue
        }
    }
    
}
