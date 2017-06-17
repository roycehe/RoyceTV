//
//  EmoticonViewModel.swift

//  Created by 何晓文 on 2017/5/4.
//  Copyright © 2017年 何晓文. All rights reserved.
//

import UIKit

class EmoticonViewModel {
    static let shareInstance : EmoticonViewModel = EmoticonViewModel()
    lazy var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        packages.append(EmoticonPackage(plistName: "QHNormalEmotionSort.plist"))
        packages.append(EmoticonPackage(plistName: "QHSohuGifSort.plist"))
    }
}
