
//
//  HomeVC.swift
//  RoyceTV
//
//  Created by 何晓文 on 2017/5/2.
//  Copyright © 2017年 何晓文. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }


}
// MARK: - *** 设置UI ***

    extension HomeVC {
        
        fileprivate func setupUI(){
        
//            setUpNavigationBar()
            setuoContentView()
            self.title = "首页"
            
            
        }
        
        
        fileprivate func setUpNavigationBar(){
        let logoImage = UIImage(named: "home-logo")
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: self, action: #selector(itemClick))
            
            let collectImage = UIImage(named: "search_btn_follow")
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(itemClick))
            //搜索框
            let searchFrame = CGRect(x: 0, y: 0, width: 200, height: 32)
            let searchBar = UISearchBar(frame: searchFrame)
            searchBar.placeholder = "房间号/主播名称"
            navigationItem.titleView = searchBar
            searchBar.searchBarStyle = .minimal
            //取出输入框
            let searchText = searchBar.value(forKey: "_searchField") as? UITextField
            searchText?.textColor = UIColor.white
             navigationController?.navigationBar.barTintColor = UIColor.black
            
        
        
        
        }
        
        fileprivate func loadData() -> [HomeType]  {
            let path = Bundle.main.path(forResource: "types", ofType: "plist")
            //取出所有数据
            let dataArray = NSArray(contentsOfFile: path!) as! [[String : Any]]
            //定义模型数组
            var tempArray = [HomeType]()
            
            for dict in dataArray {
                tempArray.append(HomeType(dict: dict))
            }
            
            return tempArray
        
        
        }
        
        fileprivate func setuoContentView(){
            let homeType = loadData()
            // 2.创建主题内容
            let style = HYTitleStyle()
            style.isScrollEnable = true
            let pageFrame = CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - 44)
            
            //取出所有Title
            let titles = homeType.map({$0.title})
            
            var childVcs = [AnchorVC]()
            for type in homeType {
                let anchorVc = AnchorVC()
                anchorVc.homeType = type
                childVcs.append(anchorVc)
            }
            let pageView = HYPageView(frame: pageFrame, titles: titles, style: style, childVcs: childVcs, parentVc: self)
            view.addSubview(pageView)
            
        
        
        }
    
    
    
    
    
    
        
}


// MARK: - *** 点击事件 ***
extension HomeVC {
    @objc func itemClick(){
    print("点击了")
    
    }
}
