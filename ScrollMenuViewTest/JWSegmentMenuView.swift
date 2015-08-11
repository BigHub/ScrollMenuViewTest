//
//  JWSegmentMenuView.swift
//  ScrollMenuViewTest
//
//  Created by jianwei on 15/8/11.
//  Copyright (c) 2015年 Jianwei. All rights reserved.
//

import UIKit

@objc protocol JWSegmentMenuViewDelegate{
   optional func selectItem(index:Int);
}

class JWSegmentMenuView: UIScrollView {
    //MARK: - 代理
    weak var segmentMenuViewDelegate:JWSegmentMenuViewDelegate?
    
    //MARK: 选中的item
    var seletedItem:JWSegmentMenuItem?{
        didSet{
            
            var scaleAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            scaleAnimation.duration = 0.2
            scaleAnimation.toValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
            oldValue?.pop_addAnimation(scaleAnimation, forKey: "scaleAnimation")
            oldValue?.selected = false
            oldValue?.showBorderLine = false
            
            var scaleAnimation2 = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            scaleAnimation2.duration = 0.2
            scaleAnimation2.toValue = NSValue(CGPoint: CGPointMake(1.3, 1.3 ))
            seletedItem?.pop_addAnimation(scaleAnimation2, forKey: "scaleAnimation2")
            seletedItem?.selected = true
            seletedItem?.showBorderLine = true
          
            let index = (self.subviews as NSArray).indexOfObject(seletedItem!)
            let previousIndex = index-1
            let nextIndex = index + 1
            
            var visibleRect:CGRect?
            if previousIndex >= 0 && nextIndex < titlesArray!.count {
                var preItem = self.subviews[previousIndex] as! JWSegmentMenuItem
                var nextItem = self.subviews[nextIndex] as! JWSegmentMenuItem
                visibleRect = CGRectMake(preItem.frame.origin.x, preItem.frame.origin.y, preItem.frame.size.width + nextItem.frame.size.width + seletedItem!.frame.size.width, preItem.frame.size.height)
            }else if previousIndex < 0 || nextIndex >= titlesArray?.count {
                visibleRect = seletedItem!.frame
            }
            
            self.scrollRectToVisible(visibleRect!, animated: true)
        }
    }
    
    //MARK: 菜单名称列表
    var titlesArray:NSArray?{
        didSet{
            
            if oldValue?.count > 0 {
                (self.subviews as NSArray).enumerateObjectsUsingBlock({ (obj:AnyObject!, index:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                    (obj as! UIButton).removeFromSuperview()
                })
            }
            
            if let titles = titlesArray {
                var x:CGFloat = 0
                titles.enumerateObjectsUsingBlock({ (obj:AnyObject!, index:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                    var button:JWSegmentMenuItem = JWSegmentMenuItem.buttonWithType(UIButtonType.Custom) as! JWSegmentMenuItem
                    button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
                    print(button.titleLabel!.frame)
                    button.titleLabel?.frame = button.bounds
                    print(button.titleLabel!.frame)
                    button.setTitle(obj as? String, forState: UIControlState.Normal)
                    button.setTitleColor(self.menuTitleColor, forState: UIControlState.Normal)
                    button.setTitleColor(self.menuTitleTintColor, forState: UIControlState.Selected)
                    button.addTarget(self, action: "selectItem:", forControlEvents: UIControlEvents.TouchUpInside)
                    var str = NSString(string: obj as! String)
                    var size = str.sizeWithAttributes([NSFontAttributeName:UIFont(name: button.titleLabel!.font.fontName, size: button.titleLabel!.font.pointSize)!])
                    size.width += 20
                    size.height = self.frame.size.height
                    button.frame = CGRectMake(x, 0.0 as CGFloat, size.width, size.height)
                    x += size.width
                    self.addSubview(button)
                })
                self.contentSize = CGSizeMake(x, self.frame.size.height)
            }
        }
    }
    
    //MARK: 菜单背景色
    var menuBackgroundColor:UIColor = UIColor(red: 172/255.0, green: 220/255.0, blue: 30/255.0, alpha: 1)
    {
        didSet{
            self.backgroundColor = menuBackgroundColor
        }
    }
    
    //MARK: 菜单名称字体颜色
    var menuTitleColor:UIColor?
    {
        didSet{
            for item in self.subviews {
                if item is JWSegmentMenuItem {
                    (item as! JWSegmentMenuItem).setTitleColor(menuTitleColor, forState: UIControlState.Normal)
                }
            }
        }
    }
    
    //MARK: 菜单被选中时的名称字体颜色
    var menuTitleTintColor:UIColor?
    {
        didSet{
            for item in self.subviews {
                if item is JWSegmentMenuItem {
                    (item as! JWSegmentMenuItem).setTitleColor(menuTitleTintColor, forState: UIControlState.Selected)
                }
            }

        }
    }
    
    //MARK: 菜单背景的下划线颜色
    var menuBackgroundUnderlineColor:UIColor = UIColor.lightGrayColor()
    {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = menuBackgroundColor
        menuTitleTintColor = UIColor.redColor()
        menuTitleColor = UIColor.whiteColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func drawRect(rect: CGRect) {
//        let underLinePath = UIBezierPath()
//        underLinePath.moveToPoint(CGPointMake(0, self.frame.size.height))
//        underLinePath.addLineToPoint(CGPointMake(self.frame.size.width, self.frame.size.height))
//        underLinePath.lineWidth = 4
//        menuBackgroundUnderlineColor.set()
//        underLinePath.stroke()
//    }
    
    //MARK: - 选中item触发的方法
    func selectItem(item:JWSegmentMenuItem){
        seletedItem = item
        segmentMenuViewDelegate?.selectItem!((self.subviews as NSArray).indexOfObject(seletedItem!))
    }

}

class JWSegmentMenuItem: UIButton {
    //MARK: 是否显示菜单item的下划线
    var showBorderLine:Bool = false {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
//    override func drawRect(rect: CGRect) {
//        if showBorderLine {
//            let path = UIBezierPath();
//            path.moveToPoint(CGPointMake(0, self.frame.height))
//            path.addLineToPoint(CGPointMake(self.frame.width, self.frame.height))
//            path.lineWidth = 6
//            titleColorForState(UIControlState.Selected)?.set()
//            path.stroke()
//        }
//    }
    
}