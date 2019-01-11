//
//  YMPageTitleView.swift
//  AllClassDemo
//
//  Created by youmy on 2018/3/18.
//  Copyright © 2018年 youmy. All rights reserved.
//

import UIKit

// MARK:- 定义协议
protocol YMPageTitleViewDelegate : class {
    
    
    /// 点击标题回调
    ///
    /// - Parameters:
    ///   - titleView: YMPageTitleView
    ///   - index: 标题tag
    func classTitleView(_ titleView : YMPageTitleView, selectedIndex index : Int)
    
    func classTitleViewCurrentIndex(_ titleView : YMPageTitleView, currentIndex index : Int)
}

/// 滚动条高度
private let kScrollLineH : CGFloat = 2
/// 默认颜色
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (36, 36, 36)
/// 选中颜色
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 66, 48)
/// 滚动条颜色
private let kBottomLineColor : (CGFloat, CGFloat, CGFloat) = (240, 240, 240)


class YMPageTitleView: UIView {
    fileprivate var currentIndex : Int = 0
    fileprivate var titles : [String]
    weak var delegate : YMPageTitleViewDelegate?
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    fileprivate var lineWidth:CGFloat
    fileprivate var lineHeight:CGFloat
    fileprivate var font:UIFont
    
    fileprivate lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = .red
        return scrollLine
    }()
    
    var cellWidth:CGFloat = 0
    var cellSpace:CGFloat = 20
    fileprivate var scale:CGFloat = 0
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - frame: CGRect
    ///   - titles: 标题
    ///   - params: (滚动条宽度，滚动条高度，字体)
    ///   - cellWidth: cell宽度
    ///   - cellSpace: cell间隔
    ///   - scale: 缩放比例
    init(frame: CGRect,
         titles:[String],
         params:(CGFloat,CGFloat,UIFont) = (50,2,UIFont.boldSystemFont(ofSize: 14)),
         cellWidth:CGFloat = 0,
         cellSpace:CGFloat = 20,scale:CGFloat = 0) {
        self.titles = titles
        self.lineWidth = params.0
        self.lineHeight = params.1
        self.font = params.2
        self.cellWidth = cellWidth
        self.cellSpace = cellSpace
        self.scale = scale
        super.init(frame: frame)
        // 设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension YMPageTitleView {
    fileprivate func setupUI() {
        // 1.添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 2.添加title对应的Label
        setupTitleLabels()
        
        // 3.设置底线和滚动的滑块
        setupBottomLineAndScrollLine()
        
    }
    
    fileprivate func setupTitleLabels(){
        var contentWidth:CGFloat = 0
        // 0.确定label的一些frame的值
//        let labelW : CGFloat = frame.width / CGFloat(titles.count > count ? count : titles.count)
//        let labelW : CGFloat = 120
        let labelH : CGFloat = frame.height - lineHeight
        let labelY : CGFloat = 0
        var labelX : CGFloat = cellSpace
        
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.tag = index
            label.font = font
            label.numberOfLines = 2
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            label.sizeToFit()
            
            let width = cellWidth == 0 ? label.bounds.width : cellWidth
            
            label.frame = CGRect(x: labelX, y: labelY, width: width, height: labelH)
            scrollView.addSubview(label)
            labelX = label.frame.maxX + cellSpace
            contentWidth = labelX
            titleLabels.append(label)
            
            // 5.给Label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            
        }
        
        scrollView.contentSize = CGSize(width: contentWidth, height: bounds.height)

    }
    
    fileprivate func setupBottomLineAndScrollLine() {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(r: kBottomLineColor.0, g: kBottomLineColor.1, b: kBottomLineColor.2)
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 2.添加scrollLine
        // 2.1.获取第一个Label
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        firstLabel.transform = CGAffineTransform(scaleX: 1 + scale, y: 1 + scale)
        
        // 2.2.设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - lineHeight, width: lineWidth, height: lineHeight)
//        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - lineH, width: firstLabel.frame.width/2.5, height: lineH)
        scrollLine.center.x = firstLabel.center.x
    }
}

// MARK:- 监听Label的点击
extension YMPageTitleView {
    @objc fileprivate func titleLabelClick(_ tapGes : UITapGestureRecognizer) {
        
        // 0.获取当前Label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        // 1.如果是重复点击同一个Title,那么直接返回
        if currentLabel.tag == currentIndex { return }
        
        // 2.获取之前的Label
        let oldLabel = titleLabels[currentIndex]
        
        // 3.切换文字的颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        // 4.保存最新Label的下标值
        currentIndex = currentLabel.tag
        
        // 5.滚动条位置发生改变
        UIView.animate(withDuration: 0.15, animations: {
            self.scrollLine.center.x = currentLabel.center.x
        })
        
        delegate?.classTitleView(self, selectedIndex: currentIndex)
    }
}

// MARK:- 对外暴露的方法
extension YMPageTitleView {
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        
        let maxScale = 1 + scale
        
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.处理滑块的逻辑
        let moveTotalX = targetLabel.center.x - sourceLabel.center.x
        let moveX = moveTotalX * progress
        scrollLine.center.x = sourceLabel.center.x + moveX
        
        // 3.颜色的渐变(复杂)
        // 3.1.取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        // sourceLabel缩放
        sourceLabel.transform = CGAffineTransform(scaleX: maxScale - scale * progress, y:maxScale - scale * progress)

        // targetLabel缩放
        targetLabel.transform = CGAffineTransform(scaleX: 1 + scale * progress, y:1 + scale * progress)
        
        if progress == 1.0 {
            // 4.记录最新的index
            currentIndex = targetIndex
            delegate?.classTitleViewCurrentIndex(self, currentIndex: currentIndex)
        }
    }
}

