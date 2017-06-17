//
//  HomeAnchorCell.swift
//  RoyceTV
//
//  Created by 何晓文 on 2017/5/4.
//  Copyright © 2017年 何晓文. All rights reserved.
//

import UIKit
import SnapKit
class HomeAnchorCell: UICollectionViewCell {
    
    // MARK: - *** 属性 ***
    
    var albumImageView : UIImageView!
    
    var liveImageView : UIImageView!
    
    var nickNameLabel : UILabel!
    
    var onlinePeopleLabel : UIButton!
    
    
    // MARK: - *** 模型 ***
    
    var anchorModel : AnchorModel? {
        
        didSet{
            albumImageView.setImage(anchorModel!.isEvenIndex ? anchorModel?.pic74 : anchorModel?.pic51, "home_pic_default")
            
            liveImageView.isHidden = anchorModel?.live == 0
            
            nickNameLabel.text = anchorModel?.name
            
            onlinePeopleLabel.setTitle("\(String(describing: anchorModel?.focus ?? 0))", for: .normal)
        
        
        
        }
    
    
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        //照片
        albumImageView = UIImageView()
        addSubview(albumImageView)
        albumImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
       //是否在线
        liveImageView = UIImageView()
        addSubview(liveImageView)
        liveImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
    
        }
        //昵称
        nickNameLabel = UILabel()
        nickNameLabel.font = UIFont.systemFont(ofSize: 10)
        nickNameLabel.textColor = UIColor.orange
        addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.contentView).offset(10)
            
            
        }
        
        //在线人数
        onlinePeopleLabel = UIButton(type: UIButtonType.custom)
        onlinePeopleLabel.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        onlinePeopleLabel.layer.cornerRadius = 2
        onlinePeopleLabel.layer.borderColor = UIColor.white.cgColor
        onlinePeopleLabel.layer.borderWidth = 0.5
        onlinePeopleLabel.layer.masksToBounds = true
        addSubview(onlinePeopleLabel)
        onlinePeopleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(nickNameLabel)
            make.height.equalTo(13);
            make.right.equalTo(self.contentView).offset(-10)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
