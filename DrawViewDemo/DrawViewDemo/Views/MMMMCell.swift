//
//  MMMMCell.swift
//  DrawViewDemo
//
//  Created by zhuyingqi on 2019/9/29.
//  Copyright © 2019 Ying Qi Zhu. All rights reserved.
//

import UIKit

class MMMMCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
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
     }
     
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: ScreenWidth, height: 188)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
