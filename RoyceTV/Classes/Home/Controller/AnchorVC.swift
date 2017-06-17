//
//  AnchorVC.swift
//  RoyceTV
//
//  Created by 何晓文 on 2017/5/4.
//  Copyright © 2017年 何晓文. All rights reserved.
//

import UIKit
private let kEdgeMargin : CGFloat = 8
private let kAnchorCellID = "kAnchorCellID"
class AnchorVC: UIViewController {

    
    // MARK: - *** 外部属性 ***
    var homeType : HomeType!
    
    // MARK: - *** 内部属性 ***
    fileprivate lazy var homeVM : HomeViewModel = HomeViewModel()
    
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = WaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: kEdgeMargin, left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        layout.minimumLineSpacing = kEdgeMargin
        layout.minimumInteritemSpacing = kEdgeMargin
        layout.dataSource = self
        
        let collection : UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.register(HomeAnchorCell.self, forCellWithReuseIdentifier: kAnchorCellID)
        collection.backgroundColor = UIColor.white
        
        return collection
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData(index: 0)
        // Do any additional setup after loading the view.
    }

 

}

// MARK:- 设置UI界面内容
extension AnchorVC {
    fileprivate func setupUI() {
        view.addSubview(collectionView)
    }
}

extension AnchorVC {
    fileprivate func loadData(index : Int) {
        homeVM.loadHomeData(type: homeType, index : index, finishedCallback: {
            self.collectionView.reloadData()
        })
    }
}

// MARK:- collectionView的数据源&代理
extension AnchorVC : UICollectionViewDataSource, WaterfallLayoutDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.anchorModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAnchorCellID, for: indexPath) as! HomeAnchorCell
        
        cell.anchorModel = homeVM.anchorModels[indexPath.item]
        
        if indexPath.item == homeVM.anchorModels.count - 1 {
            loadData(index: homeVM.anchorModels.count)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let roomVc = RoomVC()
        roomVc.anchor = homeVM.anchorModels[indexPath.item]
        navigationController?.pushViewController(roomVc, animated: true)
    }
    
    func waterfallLayout(_ layout: WaterfallLayout, indexPath: IndexPath) -> CGFloat {
        return indexPath.item % 2 == 0 ? kScreenW * 2 / 3 : kScreenW * 0.5
    }
}

