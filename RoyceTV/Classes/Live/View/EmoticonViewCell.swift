//
//  EmoticonViewCell.swift

//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 何晓文 . All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    var emoticon : Emoticon? {
        didSet {
            iconImageView.image = UIImage(named: emoticon!.emoticonName)
        }
    }
}
