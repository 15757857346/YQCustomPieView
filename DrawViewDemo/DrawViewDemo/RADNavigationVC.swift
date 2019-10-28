//
//  RADNavigationVC.swift
//  DrawViewDemo
//
//  Created by zhuyingqi on 2019/9/12.
//  Copyright © 2019 Ying Qi Zhu. All rights reserved.
//

import UIKit

class RADNavigationVC: UINavigationController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavBarAppearence()

    }
    

    func setupNavBarAppearence() {
        // 设置导航栏默认的背景颜色
        WRNavigationBar.defaultNavBarBarTintColor = UIColor.white
        // 设置导航栏所有按钮的
        WRNavigationBar.defaultNavBarTintColor = UIColor.blue
        WRNavigationBar.defaultNavBarTitleColor = UIColor.black
        // 统一设置导航栏样式
        //        WRNavigationBar.defaultStatusBarStyle = .lightContent
        // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
        WRNavigationBar.defaultShadowImageHidden = true
        
    }

}
