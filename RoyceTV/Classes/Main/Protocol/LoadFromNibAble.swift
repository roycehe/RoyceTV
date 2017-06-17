//
//  LoadFromNibAble.swift
//  RoyceTV
//
//  Created by 何晓文 on 2017/6/5.
//  Copyright © 2017年 何晓文. All rights reserved.
//

import UIKit

protocol LoadFormNibAle {
    
}

//必须是继承UIView 的类实现
extension LoadFormNibAle where Self : UIView {
    
    static func loadFromNib(_ nibName : String? = nil) -> Self {
    
        guard let loadName = nibName else {
            return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! Self
        }
        
         return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.last as! Self
    
    
    }


}
