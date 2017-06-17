//
//  ChaContentCell.swift
//  RoyceTV
//
//  Created by 何晓文 on 2017/6/6.
//  Copyright © 2017年 何晓文. All rights reserved.
//

import UIKit

class ChaContentCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.textColor = UIColor.white
        selectionStyle = .none
        
        contentView.backgroundColor = UIColor.clear

    }

 
    
}
