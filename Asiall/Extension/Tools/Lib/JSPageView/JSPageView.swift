//
//  JSPageView.swift
//  pageView


import UIKit

class JSPageView: UIView {
    // MARK: - 属性
    var titles : [String]
    var style : JS_PageStyle
    var childController : [UIViewController]
    var parentController : UIViewController
    
    
    
// MARK: - 构造函数
    init(frame: CGRect,titles:[String],style:JS_PageStyle,childController:[UIViewController],parentController:UIViewController) {
        self.titles = titles
        self.style = style
        self.childController = childController
        self.parentController = parentController
        super.init(frame: frame)
        
        //设置UI<需要在super 之后>
        setupUI()
     }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - 设置UI
extension JSPageView{
    
    fileprivate func setupUI(){
        //TitleView
        let titleFrame = CGRect(x: 0, y: 0, width:bounds.width, height: style.titleViewHeight)
        let titleView = JS_TitleView(frame: titleFrame, titles: nil, style: style)
        titleView.titles = self.titles
        titleView.backgroundColor = style.titleViewBackgroundColor
        addSubview(titleView)
       
        //ContentView
        let contentFrame = CGRect(x: 0, y: titleFrame.maxY, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = JSContentView(frame: contentFrame, childController: childController, parentController: parentController)
        contentView.backgroundColor = style.contentBackgroudColor
        addSubview(contentView)
       
        //交互
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}




