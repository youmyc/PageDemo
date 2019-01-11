//
//  ViewController.swift
//  PageDemo
//
//  Created by mac on 2019/1/7.
//  Copyright © 2019 youmy. All rights reserved.
//

import UIKit

fileprivate let screen_width = UIScreen.main.bounds.width
fileprivate let screen_height = UIScreen.main.bounds.height

class ViewController: UIViewController {
    
//    let titles = ["关注", "推荐", "新闻"]
    
    let titles = ["关注", "推荐", "新闻", "火山视频", "直播Live"]

    lazy var childVcs:[BaseViewController] = {
        var childVcs = [BaseViewController]()
        childVcs.append(AttentionViewController())
        childVcs.append(RecommandViewController())
        childVcs.append(NewsViewController())
        childVcs.append(VideoViewController())
        childVcs.append(LiveViewController())
        return childVcs
    }()
    
    // MARK:- 懒加载属性
    fileprivate lazy var pageTitleView : YMPageTitleView = {[weak self] in
        
        let statusHeight:CGFloat = screen_height >= 812 ? 44 : 20
        
        let titleFrame = CGRect(x: 0, y: statusHeight, width: screen_width, height: 44)
        let titleView = YMPageTitleView(frame: titleFrame, titles: self?.titles ?? [], params: (30, 3, UIFont.systemFont(ofSize: 15)), cellSpace:30, scale:0.2)
        
        titleView.backgroundColor = .white
        titleView.delegate = self
        return titleView
        }()
    
    fileprivate lazy var pageContentView : YMPageContentView = {[weak self] in
        
        // 1.确定内容的frame
        let contentFrame = CGRect(x: 0, y: pageTitleView.frame.maxY, width: screen_width, height: screen_height - pageTitleView.frame.maxY)
        
        // 2.确定所有的子控制器
        let childVcs = self?.childVcs
        
        let contentView = YMPageContentView(frame: contentFrame, childVcs: childVcs ?? [], parentViewController: self)
        contentView.delegate = self
        return contentView
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(pageTitleView)
        self.view.addSubview(pageContentView)
    }
}

extension ViewController: YMPageTitleViewDelegate {
    func classTitleView(_ titleView: YMPageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(index)
    }
    
    func classTitleViewCurrentIndex(_ titleView: YMPageTitleView, currentIndex index: Int) {
        /// 刷新数据
    }
}

extension ViewController: YMPageContentViewDelegate {
    func pageContentView(_ contentView: YMPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
