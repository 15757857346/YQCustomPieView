//
//  CustomPieView.swift
//  DrawViewDemo
//
//  Created by zhuyingqi on 2019/10/12.
//  Copyright © 2019 Ying Qi Zhu. All rights reserved.
//

import UIKit

enum PieAnimationType: Int {
    //所有部分只有一个动画
    case PieAnimationTypeOne = 0
    //所有部分一起动画
    case PieAnimationTypeTogether
}

enum PieCenterType: Int {
    case PieCenterTypeCenter = 0  //默认，圆心位于视图的中心
    case PieCenterTypeTopLeft     //圆位于视图的上部的左侧
    case PieCenterTypeTopMiddle   //圆位于视图的上部的中间
    case PieCenterTypeTopRight    //圆位于视图的上部的右侧
    case PieCenterTypeMiddleLeft  //圆位于视图的中部的左侧
    case PieCenterTypeMiddleRight //圆位于视图的中部的右侧
    case PieCenterTypeBottomLeft  //圆位于视图的底部的左侧
    case PieCenterTypeBottomMiddle//圆位于视图的底部的中间
    case PieCenterTypeBottomRight //圆位于视图的底部的右侧
}

class CustomPieView: UIView {
    typealias ClickBlock = ((_ clickIndex: Int) -> Void)
    ///  饼状图数据数组
    public var segmentDataArray = [String]()
    ///  饼状图标题数组
    public var segmentTitleArray = [String]()
    /// 饼状图颜色数组
    public var segmentColorArray = [UIColor]()
    ///  圆饼的半径
    public var pieRadius: CGFloat = 0
    ///  是否动画
    public var needAnimation: Bool = true
    /// 是否隐藏文本
    public var hideText: Bool = false
    /// 动画时间
    public var animateTime: CGFloat = 0.35
    ///  动画类型,默认只有一个动画
    public var type: PieAnimationType = .PieAnimationTypeOne
    ///  内圆的半径，默认大圆半径的1/3
    public var innerCircleR: CGFloat = 0
    /// 内部圆的颜色，默认白色
    public var innerColor: UIColor = UIColor.white
    ///   圆的位置，默认视图的中心
    public var centerType: PieCenterType = .PieCenterTypeCenter
    /// 右侧文本 距离右侧的间距
    public var textRightSpace: CGFloat = 0
    /// 圆心的X位置
    public var centerXPosition: CGFloat = 0
    /// 圆心的Y位置
    public var centerYPosition: CGFloat = 0
    /// 文本的高度，默认20
    public var textHeight: CGFloat = 20.0
    /// 文本前的颜色模块的高度，默认等同于文本高度
    public var colorHeight: CGFloat = 8.0
    /// 文本的字号，默认14
    public var textFontSize: CGFloat = 14
    /// 文本的行间距，默认10
    public var textSpace: CGFloat = 10.0
    /// 文本前的颜色是否为圆
    public var isRound: Bool = true
    /// 是否文本颜色等于模块颜色,默认不一样，文本默认黑色
    public var isSameColor: Bool = false
    /// 是否允许点击
    public var canClick: Bool = true
    /// 点击偏移量，默认15
    public var clickOffsetSpace: CGFloat = 15
    
    // MARK: - private
    /// 饼状图 array
    private var pieShapeLayerArray = [CustomShapeLayer]()
    /// 各个部分的coverLayer
    private var segmentCoverLayerArray = [CAShapeLayer]()
    /// 各个部分的path
    private var segmentPathArray = [UIBezierPath]()
    /// 半径
    private var pieR: CGFloat = 0
    /// 圆心
    private var pieCenter: CGPoint = CGPoint(x: 0, y: 0)
    /// 内部小圆
    private var whiteLayer = CAShapeLayer()
    ///
    private var coverCircleLayer = CAShapeLayer()
    ///  最终的文本数组
    private var finalTextArray = [String]()
    /// 颜色块位置
    private var colorRightOriginPoint: CGPoint = CGPoint(x: 0, y: 0)
    /// 实际的文本字号
    private var realTextFont: CGFloat = 13
    /// 实际的文本高度
    private var realTextHeight: CGFloat = 0
    /// 实际的文本间距
    private var realTextSpace: CGFloat = 0
    ///  小圆点数组
    private var colorPointArray = [CAShapeLayer]()
    /// 点击圆饼的index的block
    private var clickBlock: ClickBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if !self.hideText {
            drawRightText()
        }
    }
    
    // MARK: - publicMethods 绘制&点击事件
    ///添加视图
    public func showCustomViewInSuperView(superView: UIView) {
        
        pieShapeLayerArray.removeAll()
        segmentCoverLayerArray.removeAll()
        segmentPathArray.removeAll()
        colorPointArray.removeAll()
        
        if segmentColorArray.count == 0 {
            segmentColorArray = loadRandomColorArray()
        }
        superView.addSubview(self)
        
        if !needAnimation {
            loadNoAnimation()
            return
        }
        if type == .PieAnimationTypeTogether {
            loadTogetherAnimation()
        } else {
            loadOneAnimation()
        }
        
    }
    //圆饼的点击事件
    public func clickPieView(clickBlock: @escaping (Int) -> Void) {
        self.clickBlock = clickBlock
    }
    
    /// 更新圆饼
    public func updatePieView() {
        
        whiteLayer.removeFromSuperlayer()
        for layer in pieShapeLayerArray {
            layer.removeFromSuperlayer()
        }
        for layer in colorPointArray {
            layer.removeFromSuperlayer()
        }
        colorPointArray.removeAll()
        pieShapeLayerArray.removeAll()
        segmentCoverLayerArray.removeAll()
        segmentPathArray.removeAll()
        
        setNeedsDisplay()
        
        if !needAnimation {
            loadNoAnimation()
            return
        }
        
        if type == .PieAnimationTypeTogether {
            loadTogetherAnimation()
        } else {
            loadOneAnimation()
        }
    }
    
    /// 选中的index，不设置的话，没有选中的模块
    public func setPieSelectedIndex(_ selectedIndex: Int) {
        if canClick && selectedIndex < pieShapeLayerArray.count {
            let layer = pieShapeLayerArray[selectedIndex]
            layer.isSelected = true
            dealClickCircleWithIndex(selectedIndex)
        }
    }
    
    // MARK: - 绘制右侧的文本
    private func drawRightText() {
        let view_W = self.bounds.size.width
        let color_H = preferGetUserSetValue(userValue: colorHeight, deafultValue: realTextHeight)
        
        let textX: CGFloat = colorRightOriginPoint.x + color_H + 12 ////文本前面有一个颜色方块／圆
        let textY: CGFloat = colorRightOriginPoint.y
        
        for (index, content) in finalTextArray.enumerated() {
            var textColor = UIColor.black
            if isSameColor {
                if index < self.segmentColorArray.count {
                    textColor = segmentColorArray[index]
                }
            }
            
            let textUseHeight = heightForTextString(vauleString: content, textwidth: 1000, fontSize: self.realTextFont)
            let textOffset: CGFloat = (realTextHeight - textUseHeight)/2
            let index_f = CGFloat(index)
            let content_y: CGFloat = textY + realTextSpace * index_f + realTextHeight * index_f + textOffset
            
            /// 没找到swift 只能先转成NSString
            let content_OC = content as NSString
            content_OC.draw(in: CGRect(x: textX, y: content_y, width: view_W - textX, height: realTextHeight), withAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: realTextFont), NSAttributedString.Key.foregroundColor:textColor])
            
        }
        
    }
    
}

// MARK: 点击事件
extension CustomPieView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !canClick { return }
        guard let touchPoint = touches.first?.location(in: self) else { return }
        for shapeLayer in pieShapeLayerArray {
            
            // 如果只有一个模块，那么动画就要变化了，不是简单的偏移了
            if segmentDataArray.count == 1 {
                shapeLayer.isOneSection = true
            }
            
            // 判断选择区域
            shapeLayer.clickOffset = preferGetUserSetValue(userValue: clickOffsetSpace, deafultValue: 15)
            
            if shapeLayer.path?.contains(touchPoint) == true {
                shapeLayer.isSelected = !shapeLayer.isSelected
                let index = pieShapeLayerArray.firstIndex(of: shapeLayer)
                if let result = index {
                    dealClickCircleWithIndex(result)
                }
            } else {
                shapeLayer.isSelected = false
            }
        }
    }
    
    private func dealClickCircleWithIndex(_ index: Int) {
        clickBlock?(index)
        
        if index < colorPointArray.count {
            let layer = colorPointArray[index]
            /// 加个动画噻
            let animation = CAKeyframeAnimation(keyPath: "transform.scale")
            animation.values = [0.9,2.0,1.5,0.7,1.3,1.0]
            animation.calculationMode = .cubic
            animation.duration = 0.8
            layer.add(animation, forKey: "scaleAnimation")
        }
    }
    
}


// MARK: Datas
extension CustomPieView {
    
    private func loadPieCenter() {
        let view_W = self.bounds.size.width
        let view_H = self.bounds.size.height
        // 圆心
        pieCenter = CGPoint(x: view_W/2, y: view_H/2)
        switch centerType {
        case .PieCenterTypeCenter:
            pieCenter = CGPoint(x: view_W/2, y: view_H/2)
        case .PieCenterTypeTopLeft:
            pieCenter = CGPoint(x: pieR, y: pieR)
        case .PieCenterTypeTopMiddle:
            pieCenter = CGPoint(x: view_W/2, y: pieR)
        case .PieCenterTypeTopRight:
            pieCenter = CGPoint(x: view_W - pieR, y: pieR)
        case .PieCenterTypeMiddleLeft:
            pieCenter = CGPoint(x: pieR, y: view_H/2)
        case .PieCenterTypeMiddleRight:
            pieCenter = CGPoint(x: view_W - pieR, y: view_H/2)
        case .PieCenterTypeBottomLeft:
            pieCenter = CGPoint(x:  pieR, y: view_H - pieR)
        case .PieCenterTypeBottomMiddle:
            pieCenter = CGPoint(x:  view_W/2, y: view_H - pieR)
        case .PieCenterTypeBottomRight:
            pieCenter = CGPoint(x: view_W - pieR, y: view_H - pieR)
        }
    }
    
    private func loadRandomColorArray() -> [UIColor] {
        var colorArray = [UIColor]()
        for _ in segmentDataArray {
            colorArray.append(loadRandomColor())
        }
        return colorArray
    }
    
    /// 随机色
    private func loadRandomColor() -> UIColor {
        let r = getRandomNumber(fromValue: 1, toValue: 255)
        let g = getRandomNumber(fromValue: 1, toValue: 255)
        let b = getRandomNumber(fromValue: 1, toValue: 255)
        return UIColor(hue: r, saturation: g, brightness: b, alpha: 1.0)
    }
    
    private func getRandomNumber(fromValue: Int, toValue: Int) -> CGFloat {
        let space: UInt32 = UInt32(toValue - fromValue)
        let value_Int = fromValue + Int(arc4random() % space)
        return CGFloat(value_Int)/255.0
    }
}


// MARK: - 画饼状图
extension CustomPieView {
    
    private func doSegmentAnimation() {
        
        for layer in segmentCoverLayerArray {
            doCustomAnimation(layer: layer)
        }
    }
    // MARK: - 计算右侧显示文本的frame
    private func loadRightTextAndColor() {
        
        let view_W = self.bounds.size.width
        let view_H = self.bounds.size.height
        
        var maxWidth: CGFloat = 0
        for(_, valueString) in finalTextArray.enumerated() {
            let finalWidth = widthForTextString(vauleString: valueString, tHeight: realTextHeight, fontSize: realTextFont)
            if finalWidth > maxWidth {
                maxWidth = finalWidth
            }
        }
        
        let colorHeight: CGFloat = preferGetUserSetValue(userValue: self.colorHeight, deafultValue: realTextHeight)
        
        let textRightSpace: CGFloat = preferGetUserSetValue(userValue: self.textRightSpace, deafultValue: 0)
        
        let colorOriginX: CGFloat = view_W - maxWidth - colorHeight - textRightSpace
        
        let colorOriginY: CGFloat = (view_H - (realTextHeight * CGFloat(finalTextArray.count) + realTextSpace * CGFloat((finalTextArray.count - 1))))/2
        
        colorRightOriginPoint = CGPoint(x: colorOriginX, y: colorOriginY)
        
        for(i , _) in finalTextArray.enumerated() {
            
            let colorLayer = CAShapeLayer()
            let spaceHeight = (realTextHeight - colorHeight)/2
            colorLayer.frame = CGRect(x: colorOriginX, y: colorOriginY + (realTextSpace + realTextHeight) * CGFloat(i) +  spaceHeight, width: colorHeight, height: colorHeight)
            var segColor = UIColor.cyan
            
            if i < segmentColorArray.count {
                segColor = segmentColorArray[i]
            }
            colorLayer.backgroundColor = segColor.cgColor
            
            if isRound {
                colorLayer.cornerRadius = colorHeight/2
            }
            colorPointArray.append(colorLayer)
            self.layer.addSublayer(colorLayer)
        }
        
    }
    
    // MARK:- 处理展示的文本
    private func loadFinalText() {
        realTextHeight = preferGetUserSetValue(userValue: textHeight, deafultValue: 20)
        realTextFont = preferGetUserSetValue(userValue: textFontSize, deafultValue: 14)
        realTextSpace = preferGetUserSetValue(userValue: textSpace, deafultValue: 10)
        
        var totalValue: CGFloat = 0
        for value in segmentDataArray {
            if let doubleValue = Double(value) {
                totalValue += CGFloat(doubleValue)
            }
        }
        
        finalTextArray.removeAll()
        
        for(index, valueString) in segmentDataArray.enumerated() {
            //文本对应的数据值
            let value = stringToCGFloat(valueString)
            //当前数值的占比
            let rate: CGFloat = value/totalValue
            var titleString = "其他"
            if index < segmentTitleArray.count {
                titleString = segmentTitleArray[index]
            }
            let finalString = String(format: "%@ %.1f%%", titleString, rate*100)
            finalTextArray.append(finalString)
        }
    }
    
    private func loadOneAnimation() {
        if !hideText {
            loadTextContent()
        }
        loadPieView()
        doCustomAnimation(layer: coverCircleLayer)
    }
    
    // MARK: -  加载一个动画的饼状图
    private func loadPieView() {
        //放置layer的主layer，如果没有这个layer，那么设置背景色就无效了，因为被mask了。
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.frame = self.bounds
        layer.addSublayer(backgroundLayer)
        
        // 半径
        pieR = preferGetUserSettingRadiusValue()
        // 圆心
        loadPieCenter()
        if centerXPosition > 0 {
            pieCenter = CGPoint(x: centerXPosition, y: pieCenter.y)
        }
        
        if centerYPosition > 0 {
            pieCenter = CGPoint(x: pieCenter.x, y: centerYPosition)
        }
        
        //数据总值
        var totalValue: CGFloat = 0.0
        //当前开始的弧度,这里初始的角度要和self.coverCircleLayer遮罩的初始角度一致，否则，颜色模块会被分割开
        var currentRadian = -CGFloat.pi/2
        
        for valueString in segmentDataArray {
            if let mValue = Double(valueString) {
                totalValue += CGFloat(mValue)
            }
        }
        
        let offset = preferGetUserSetValue(userValue: clickOffsetSpace, deafultValue: 15)
        let innerWhiteRadius = preferGetUserSetValue(userValue: innerCircleR, deafultValue: pieR/3)
        let innerColor = preferGetUserSetColor(userColor: self.innerColor, deafultColor: UIColor.white)
        
        for (index, valueString) in segmentDataArray.enumerated() {
            //数据值
            let value = stringToCGFloat(valueString)
            //根据当前数值的占比，计算得到当前的弧度
            let radian = loadPercentRadianWithCurrent(current: value, totalValue: totalValue)
            //弧度结束值 初始值＋当前弧度
            let endAngle = currentRadian + radian
            
            // 贝塞尔曲线
            let path = UIBezierPath()
            path.move(to: pieCenter)
            //圆弧 默认最右端为0，YES时为顺时针。NO时为逆时针。
            path.addArc(withCenter: pieCenter, radius: pieR, startAngle: currentRadian, endAngle: endAngle, clockwise: true)
            path.addArc(withCenter: pieCenter, radius: innerWhiteRadius, startAngle: endAngle, endAngle: currentRadian, clockwise: false)
            
            //添加到圆心直线
            path.addLine(to: pieCenter)
            // 路径闭合
            path.close()
            
            let radiusLayer = CustomShapeLayer()
            // 设置layer的路径
            radiusLayer.centerPoint = pieCenter
            radiusLayer.startAngle = currentRadian
            radiusLayer.endAngle = endAngle
            radiusLayer.radius = pieR
            radiusLayer.innerColor = innerColor
            radiusLayer.innerRadius = innerWhiteRadius
            radiusLayer.path = path.cgPath
            
            //下一个弧度开始位置为当前弧度的结束位置
            currentRadian = endAngle
            
            // 默认颜色
            var deafult_Color: UIColor = UIColor.cyan
            if index < segmentColorArray.count {
                deafult_Color = segmentColorArray[index]
            }
            radiusLayer.fillColor = deafult_Color.cgColor.copy(alpha: 1.0);
            pieShapeLayerArray.append(radiusLayer)
            backgroundLayer.addSublayer(radiusLayer)
        }
        
        //贝塞尔曲线
        let innerPath = UIBezierPath()
        innerPath.addArc(withCenter: pieCenter, radius: pieR/2 + offset, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi*3/2, clockwise: true)
        
        // 初始化layer
        coverCircleLayer.lineWidth = pieR + offset * 2
        coverCircleLayer.strokeStart = 0
        coverCircleLayer.strokeEnd = 1
        //Must 如果stroke没有颜色，那么动画没法进行了
        coverCircleLayer.strokeColor = UIColor.black.cgColor
        //决定内部的圆是否显示,如果clearColor，则不会在动画开始时就有各个颜色的、完整的内圈。
        coverCircleLayer.fillColor = UIColor.clear.cgColor
        coverCircleLayer.path = innerPath.cgPath
        backgroundLayer.mask = coverCircleLayer
        
        //内圈的小圆
        let whitePath = UIBezierPath(arcCenter: pieCenter, radius: innerWhiteRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        whiteLayer.path = whitePath.cgPath
        whiteLayer.fillColor = innerColor.cgColor
        layer.addSublayer(whiteLayer)
        
    }
    
    private func doCustomAnimation(layer: CAShapeLayer) {
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0
        strokeAnimation.duration = CFTimeInterval(animateTime > 0 ? animateTime:4)
        strokeAnimation.toValue = 1
        // 有无自动恢复效果
        strokeAnimation.autoreverses = false
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeAnimation.isRemovedOnCompletion = true
        layer.add(strokeAnimation, forKey: "strokeEndAnimation")
        layer.strokeEnd = 1
    }
    
    // MARK:- 加载文本并调整饼状图中心
    private func loadTextContent() {
        loadFinalText()
        centerType = .PieCenterTypeMiddleLeft
        loadRightTextAndColor()
    }
    // MARK: - 加载文本并调整饼状图中心
    private func loadCustomPieView() {
        // 半径
        pieR = preferGetUserSettingRadiusValue()
        // 圆心
        loadPieCenter()
        if centerXPosition > 0 {
            pieCenter = CGPoint(x: centerXPosition, y: pieCenter.y)
        }
        
        if centerYPosition > 0 {
            pieCenter = CGPoint(x: pieCenter.x, y: centerYPosition)
        }
        
        var totalValue: CGFloat = 0
        ///当前开始的弧度,这里初始的角度要和self.coverCircleLayer遮罩的初始角度一致，否则，颜色模块会被分割开
        var currentRadian = CGFloat.pi/2
        for valueString in segmentDataArray {
            totalValue += stringToCGFloat(valueString)
        }
        
        let offset = preferGetUserSetValue(userValue: clickOffsetSpace, deafultValue: 15)
        let innerWhiteRadius = preferGetUserSetValue(userValue: innerCircleR, deafultValue: pieR/3)
        let innerColor = preferGetUserSetColor(userColor: self.innerColor, deafultColor: UIColor.white)
        
        for (index, valueString) in segmentDataArray.enumerated() {
            //数据值
            let value = stringToCGFloat(valueString)
            //根据当前数值的占比，计算得到当前的弧度
            let radian = loadPercentRadianWithCurrent(current: value, totalValue: totalValue)
            //弧度结束值 初始值＋当前弧度
            let endAngle = currentRadian + radian
            
            // 贝塞尔曲线
            let path = UIBezierPath()
            path.move(to: pieCenter)
            //圆弧 默认最右端为0，YES时为顺时针。NO时为逆时针。
            path.addArc(withCenter: pieCenter, radius: pieR, startAngle: currentRadian, endAngle: endAngle, clockwise: true)
            path.addArc(withCenter: pieCenter, radius: innerWhiteRadius, startAngle: endAngle, endAngle: currentRadian, clockwise: false)
            
            //添加到圆心直线
            path.addLine(to: pieCenter)
            // 路径闭合
            path.close()
            
            //当前shapeLayer的遮罩
            let coverPath = UIBezierPath(arcCenter: pieCenter, radius: pieR/2+offset, startAngle: currentRadian, endAngle: endAngle, clockwise: true)
            segmentPathArray.append(coverPath)
            
            let radiusLayer = CustomShapeLayer()
            // 设置layer的路径
            radiusLayer.centerPoint = pieCenter
            radiusLayer.startAngle = currentRadian
            radiusLayer.endAngle = endAngle
            radiusLayer.radius = pieR
            radiusLayer.innerColor = innerColor
            radiusLayer.innerRadius = innerWhiteRadius
            radiusLayer.path = path.cgPath
            
            //下一个弧度开始位置为当前弧度的结束位置
            currentRadian = endAngle
            
            // 默认颜色
            var deafult_Color: UIColor = UIColor.cyan
            if index < segmentColorArray.count {
                deafult_Color = segmentColorArray[index]
            }
            radiusLayer.fillColor = deafult_Color.cgColor.copy(alpha: 1.0);
            pieShapeLayerArray.append(radiusLayer)
            layer.addSublayer(radiusLayer)
        }
        
        
        for(i, path) in segmentPathArray.enumerated() {
            let originLayer = pieShapeLayerArray[i]
            let layer = CAShapeLayer()
            layer.lineWidth = pieR + offset * 2
            layer.strokeStart = 0
            layer.strokeEnd = 0
            layer.strokeColor = UIColor.black.cgColor
            layer.fillColor = UIColor.clear.cgColor
            layer.path = path.cgPath
            originLayer.mask = layer
            segmentCoverLayerArray.append(layer)
        }
        
        //内圈的小圆
        let whitePath = UIBezierPath(arcCenter: pieCenter, radius: innerWhiteRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        whiteLayer.path = whitePath.cgPath
        whiteLayer.fillColor = innerColor.cgColor
        layer.addSublayer(whiteLayer)
    }
    
    // MARK: - 无动画的饼状图
    private func loadNoAnimation() {
        loadTextContent()
        loadPieView()
    }
    
    private func loadTogetherAnimation() {
        if !self.hideText {
            loadTextContent()
        }
        loadCustomPieView()
        doSegmentAnimation()
    }
}

// MARK: Tool
extension CustomPieView {
    private func stringToCGFloat(_ value: String) -> CGFloat {
        if let mValue = Double(value) {
            return CGFloat(mValue)
        }
        return 0.0
    }
    
    // MARK:- 根据百分比 分配弧度
    private func loadPercentRadianWithCurrent(current: CGFloat, totalValue: CGFloat) -> CGFloat {
        let percent: CGFloat = current/totalValue
        return percent * CGFloat.pi * 2.0
    }
    
    // MARK:- 优先获取用户设置的圆饼半径
    private func preferGetUserSettingRadiusValue() -> CGFloat {
        let view_W = self.bounds.size.width
        let view_H = self.bounds.size.height
        let minValue = view_W > view_H ? view_H:view_W
        
        var pieRadius: CGFloat = 0.0
        if self.pieRadius > 0 {
            // 如果设置了圆饼的半径
            pieRadius = self.pieRadius
            // 如果设置的圆饼半径太大，则取能显示的最大值
            if pieRadius > minValue/2 {
                pieRadius = minValue/2
            }
        } else {
            // 如果没有设置圆饼的半径
            pieRadius = minValue/2
        }
        return pieRadius
    }
    
    private func preferGetUserSetInnerRadiusValue(userValue: CGFloat, deafultValue: CGFloat) -> CGFloat {
        return userValue > 0 ? userValue:deafultValue
    }
    
    private func preferGetUserSetValue(userValue: CGFloat, deafultValue: CGFloat) -> CGFloat {
        return userValue > 0 ? userValue:deafultValue
    }
    
    private func preferGetUserSetColor(userColor: UIColor?, deafultColor: UIColor) -> UIColor {
        return (userColor != nil) ? userColor!:deafultColor
    }
    
    // MARK:- 计算文本的宽、高
    func heightForTextString(vauleString: String, textwidth: CGFloat, fontSize: CGFloat) -> CGFloat {
        let dic = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)]
        let rect = NSString(string: vauleString).boundingRect(with: CGSize(width: textwidth, height: CGFloat(MAXFLOAT)), options: [.usesFontLeading, .usesLineFragmentOrigin, .truncatesLastVisibleLine], attributes: dic, context:nil)
        return rect.size.height
    }
    
    func widthForTextString(vauleString: String, tHeight: CGFloat, fontSize: CGFloat) -> CGFloat {
        let dic = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)]
        let rect = NSString(string: vauleString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: tHeight), options:  [.usesFontLeading, .usesLineFragmentOrigin, .truncatesLastVisibleLine], attributes: dic, context:nil)
        return rect.size.width + 5
    }
}
