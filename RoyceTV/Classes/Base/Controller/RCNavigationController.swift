//
//  RCNavigationController.swift
//  RoyceTV
//
//  Created by 何晓文 on 2017/5/2.
//  Copyright © 2017年 何晓文. All rights reserved.
//

import UIKit

class RCNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configGestrue()
        

    }
    func configGestrue() -> () {
        guard let targets = interactivePopGestureRecognizer!.value(forKey: "_targets") as? [NSObject] else {
            return
        }
        let targetObj = targets[0]
        let target = targetObj.value(forKey: "target")
        let action = Selector(("handleNavigationTransition:"))
        let panGestrue = UIPanGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(panGestrue)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
        
    }


}
