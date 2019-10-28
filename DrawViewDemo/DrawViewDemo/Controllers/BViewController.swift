//
//  BViewController.swift
//  DrawViewDemo
//
//  Created by zhuyingqi on 2019/9/12.
//  Copyright © 2019 Ying Qi Zhu. All rights reserved.
//

import UIKit

enum SSSSMethods {
    case addButtons(num: Int)
    case addImageView(num:Int)
}

class BViewController: UIViewController {
    private let tabview = UITableView(frame: .zero, style: .plain)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.gray
        navigationController?.navigationBar.isTranslucent = false
//        navBarBackgroundAlpha = 1
        navigationItem.title = "222"
        addTabview()

    }
    
    func ssss_test(method: SSSSMethods) {
        switch method {
        case .addButtons(num: 1):
            print("sss")
        default:
            break
        }
    }
    
    fileprivate func addTabview() {
        view.addSubview(tabview)
        tabview.frame = view.bounds
        tabview.backgroundColor = UIColor.white
        tabview.delegate = self
        tabview.dataSource = self
        tabview.allowsSelection = false
        tabview.separatorStyle = .none
        tabview.estimatedRowHeight = 200
        tabview.showsVerticalScrollIndicator = false
        tabview.sectionHeaderHeight = 0.01
        tabview.sectionFooterHeight = 0.01
        tabview.register(MMMMCell.self, forCellReuseIdentifier: "MMMMCell")
        tabview.register(CustomHeightCell.self, forCellReuseIdentifier: "CustomHeightCell")
        if #available(iOS 11.0, *) {
            tabview.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
}

extension BViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomHeightCell", for: indexPath) as! CustomHeightCell
        cell.mLabel.text = "我是第几行？？第\(indexPath.row)行"
        return cell
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 100
        } else {
            return UITableView.automaticDimension
        }
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
