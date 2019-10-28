//
//  MainTabbarController.swift
//  RapidAdvertising
//
//  Created by 张帅 on 2018/11/30.
//  Copyright © 2018 kaiyu. All rights reserved.
//

import UIKit
import ESTabBarController_swift
let kNavBarBottom = WRNavigationBar.navBarBottom()
/// 屏幕的宽度
let ScreenWidth: CGFloat = UIScreen.main.bounds.width
/// 屏幕的高度
let ScreenHeight: CGFloat = UIScreen.main.bounds.height

extension UIImage {
    /// 导航条分割线颜色
    static func barShadowImage(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: ScreenWidth, height: 0.5), false, 0)
        let path = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 0.5))
        color.setFill()// 自定义NavigationBar分割线颜色
        path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


class MainTabbarController: UITabBarController {
    private var clickIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
                let home = AViewController()
                let listen = BViewController()
                let play = CViewController()
                let lineChart = ViewController()
                let homeNav = RADNavigationVC.init(rootViewController: home)
                let listenNav = RADNavigationVC.init(rootViewController: listen)
                let playNav = RADNavigationVC.init(rootViewController: play)
                let line = RADNavigationVC.init(rootViewController: lineChart)
                self.viewControllers = [homeNav, listenNav, playNav, line]
        tabBar.barTintColor = UIColor.white
        tabBar.shadowImage = UIImage.barShadowImage(color: UIColor.gray)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        barItems()
    }
    
    private func barItems() {
        let items: [(title: String,image: String)] = [("首页","tabbar_global_icon_shouye"),("广告","tabbar_global_icon_guanggao"),("工具","home_icon_gongju"), ("折线图","home_icon_gongju")]
        for (index, value) in items.enumerated() {
            fillItems(title: value.title, imageName: value.image, index: index)
        }
    }
    
    private func fillItems(title: String, imageName: String, index: Int) {
        let item: UITabBarItem = tabBar.items![index]
        item.title = title
        item.image = UIImage(named: imageName)
        item.selectedImage = UIImage(named: "\(imageName)_se")
    }
    
    // MARK: - 放大动画
    func tabbarItemAnimationWithIndex(index: Int) {
        var tabbarItem : [UIView] = []
        for tabBarButton in tabBar.subviews{
            if tabBarButton.isKind(of: NSClassFromString("UITabBarButton")!){
                tabbarItem.append(tabBarButton)
            }
        }
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulse.duration = 0.1
        pulse.repeatCount = 1
        pulse.fromValue = NSNumber.init(value: 0.8)
        pulse.toValue = NSNumber.init(value: 1.2)
        //        pulse.valus = [1.0, 1.3, 1.5, 1.25, 0.8, 1.25, 1.0]
        let itemView = tabbarItem[index]
        itemView.layer.add(pulse, forKey: "")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items?.firstIndex(of: item)
        tabbarItemAnimationWithIndex(index: index ?? 0)
    }
}

extension MainTabbarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    
        clickIndex = selectedIndex
    }
    
}

