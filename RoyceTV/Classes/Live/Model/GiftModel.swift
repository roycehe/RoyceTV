//
//  GiftModel.swift
//  RoyceTV
//
//  Created by 何晓文 on 2017/6/6.
//  Copyright © 2017年 何晓文. All rights reserved.
//

import UIKit

class GiftModel: BaseModel {
    var img2 : String = ""
    var coin : Int = 0
    var subject : String = "" {
        didSet{
            if subject.contains("(有声)") {
                subject = subject.replacingOccurrences(of: "(有声)", with: "")
            }
            
        }
    
    }
    
    
    
}
