//
//  PageCollectionView.swift
//  RoyceTV
//
//  Created by 何晓文 on 2017/5/25.
//  Copyright © 2017年 何晓文. All rights reserved.
//

import UIKit

protocol PageCollectionViewDataSource: class {
    
    func numberOfSections(in pageCollectionView : PageCollectionView) -> Int
    func pageCollectionView(_ collectionView: PageCollectionView, numberOfItemsInSection section: Int) -> Int
    func pageCollectionView(_ pageCollectionView : PageCollectionView ,_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell

}

protocol PageCollecionViewDelegate: class {

    func pageCollectionView(_ pageCollectionView: PageCollectionView, didSelectItemAt indexPath: IndexPath)

}

class PageCollectionView: UIView {

    // MARK: 对外访问
    weak var dataSource : PageCollectionViewDataSource?
    weak var delegate : PageCollecionViewDelegate?
    
    // MARK: 内部属性
    fileprivate var titles : [String]
    fileprivate var style : HYTitleStyle
    fileprivate var isTitleInTop : Bool = false
    fileprivate var layout : ContentFlowLayout
    
    fileprivate var titleView : HYTitleView!
    fileprivate var collectionView : UICollectionView!
    fileprivate var pageControl : UIPageControl!
    
    fileprivate var sourceIndexPath : IndexPath = IndexPath(item: 0, section: 0)
    
    init(frame: CGRect, titles : [String], style : HYTitleStyle, isTitleInTop : Bool, layout : ContentFlowLayout) {
        
        self.titles = titles
        self.style = style
        self.isTitleInTop = isTitleInTop
        self.layout = layout
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - *** 设置UI ***
extension PageCollectionView {
    fileprivate func setupUI() {
        let titleH : CGFloat = 44
        var titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
        titleFrame.origin.y = isTitleInTop ? 0 : frame.height - titleH
        titleView = HYTitleView(frame: titleFrame, titles: titles, style: style)
        addSubview(titleView)
        titleView.delegate = self
        
        let pageControlH : CGFloat = 20
        var pageControlFrame = CGRect(x: 0, y: 0, width: frame.width, height: pageControlH)
        pageControlFrame.origin.y = isTitleInTop ? frame.height - pageControlH : frame.height - titleH - pageControlH
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.numberOfPages = 4
        pageControl.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        addSubview(pageControl)
        
        var collectionViewFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - titleH - pageControlH)
        collectionViewFrame.origin.y = isTitleInTop ? titleFrame.maxY : 0
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        addSubview(collectionView)
    }
    
}

// MARK: - ***注册和刷新 ***

extension PageCollectionView {
    func register(cellClass : AnyClass?, forCellID : String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: forCellID)
    }
    
    func regist(nib : UINib?, forCellID : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: forCellID)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}
// MARK: - *** delegate ***
extension PageCollectionView : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numOfSection = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        
        if section == 0 {
            let numOfPage = (numOfSection - 1) / (layout.cols * layout.rows) + 1
            pageControl.numberOfPages = numOfPage
        }
        
        return numOfSection
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageCollectionView(self, collectionView,cellForItemAt: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView(self, didSelectItemAt: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewDidEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionViewDidEndScroll()
        }
    }
    
    func collectionViewDidEndScroll() {
        
        // 1.取出在屏幕中显示的Cell
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        // 2.判断分组是否有发生改变
        if sourceIndexPath.section != indexPath.section {
            // 3.1.修改pageControl的个数
            let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            
            // 3.2.设置titleView位置
            titleView.setTitleWithProgress(1.0, sourceIndex: sourceIndexPath.section, targetIndex: indexPath.section)
            
            // 3.3.记录最新indexPath
            sourceIndexPath = indexPath
        }
        
        // 3.根据indexPath设置pageControl
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
    }

}

// MARK: - *** 标题滚动 ***
extension PageCollectionView : HYTitleViewDelegate {
    func titleView(_ titleView: HYTitleView, selectedIndex index: Int) {
        let indexPath = IndexPath(item: 0, section: index)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        collectionViewDidEndScroll()
    }
}

