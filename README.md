# PageDemo

## Usage：

Just download the project, and drag and drop the "PageDemo/Common" folder in your project.

```objc
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
        let titleView = YMPageTitleView(frame: titleFrame, titles: self?.titles ?? [], params: (30, 3, UIFont.systemFont(ofSize: 15)), cellSpace:30)
        
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
```

## Effect:

![](https://github.com/youmyc/PageDemo/blob/master/page.gif)
![](https://gitee.com/yom/PageDemo/raw/master/page.gif)