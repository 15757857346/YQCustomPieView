//
//  CViewController.swift
//  DrawViewDemo
//
//  Created by zhuyingqi on 2019/9/12.
//  Copyright © 2019 Ying Qi Zhu. All rights reserved.
//

import UIKit

class CViewController: UIViewController {
    // - 导航栏左边按钮
    private lazy var leftBarButton:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x:0, y:0, width:30, height: 30)
        button.setImage(UIImage(named: "msg"), for: .normal)
//        button.addTarget(self, action: #selector(leftBarButtonClick), for: UIControl.Event.touchUpInside)
        return button
    }()
    // - 导航栏右边按钮
    private lazy var rightBarButton:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x:0, y:0, width:30, height: 30)
        button.setImage(UIImage(named: "set"), for: UIControl.State.normal)
//        button.addTarget(self, action: #selector(rightBarButtonClick), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    private let tableView: UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.showsVerticalScrollIndicator = false
        tab.bounces = false
        tab.sectionFooterHeight = 0.01
        tab.sectionHeaderHeight = 0.01
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tab
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.yellow
        self.navigationItem.title = "我的"

        addTabview()
        
        // 导航栏左右item
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
        navBarBackgroundAlpha = 0
        
    }
    
    // MARK: - UI
    private func addTabview() {
        view.addSubview(tableView)
        tableView.frame = CGRect(x:0, y:0, width:ScreenWidth, height:ScreenHeight)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: -CGFloat(kNavBarBottom), left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if (offsetY > 0)
        {
            let alpha = offsetY / CGFloat(300)
            navBarBackgroundAlpha = alpha
        }else{
            navBarBackgroundAlpha = 0
        }
    }
}
extension CViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "我是第几行？？ 第\(indexPath.row)行"
        cell.backgroundColor = UIColor.orange
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  section == 0 ? 0.01:10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = UIColor.lightGray
    }
}
