//
//  ZZProtocol.swift
//  DrawViewDemo
//
//  Created by zhuyingqi on 2019/10/23.
//  Copyright © 2019 Ying Qi Zhu. All rights reserved.
//

import Foundation
import UIKit




protocol AddButtonItemProtocol {
    var wheel: Int { get set }
    // protocol的方法被mutating修饰，才能保证struct和enum实现时可以改变属性的值
    mutating func changeWheel()
//    func getBarButtonItem(title : String , action : Selector) -> UIBarButtonItem
}
    
extension AddButtonItemProtocol {
    
    ///只有文字
    func getBarButtonItem(title : String , action : Selector) -> UIBarButtonItem {

        return _getBarButtonItem(title: title, image: nil, action: action)
    }
    
    ///只有图片
    func getBarButtonItem(image : UIImage , action : Selector) -> UIBarButtonItem{
        
        return _getBarButtonItem(title: nil, image: image, action: action)
    }
    
    
    private func _getBarButtonItem(title : String? = nil , image:UIImage? = nil , action : Selector) -> UIBarButtonItem{
        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 30))
        rightbtn.setTitle(title, for: .normal)
        rightbtn.setTitleColor(UIColor.darkGray , for: .normal)
        rightbtn.setImage(image, for: .normal)
        rightbtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 30, bottom: 5, right: 10)
        
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: action , for: .touchUpInside)
        
        
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        
        return rightitem
    }
}


struct Bike: AddButtonItemProtocol {
    var wheel: Int
    mutating func changeWheel() {
        wheel = 3
    }
}


protocol Vehicle_SSSS {
    static func wheel() -> Int
}


struct Vehicle_QQQQ: Vehicle_SSSS {
    static func wheel() -> Int {
        return 4
    }
}


class Vehicle_YYYY: Vehicle_SSSS {
    static func wheel() -> Int {
        return 3
    }
}
