//
//  CustomHeightCell.swift
//  DrawViewDemo
//
//  Created by zhuyingqi on 2019/9/29.
//  Copyright © 2019 Ying Qi Zhu. All rights reserved.
//

import UIKit
import SnapKit

class CustomHeightCell: UITableViewCell {

    let mLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addSubviews() {
        contentView.addSubview(mLabel)
        mLabel.numberOfLines = 0
        mLabel.text = "ssssss"
        mLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().offset(-10)
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
