//
//  ViewController.swift
//  ScrollMenuViewTest
//
//  Created by jianwei on 15/8/10.
//  Copyright (c) 2015年 Jianwei. All rights reserved.
//

import UIKit

class ViewController: UIViewController,JWSegmentMenuViewDelegate {
    @IBOutlet weak var textLabel: UILabel!
    var segmentView:JWSegmentMenuView?

    lazy var titlesArray:[String] = {
        return ["按钮一","按钮二","按钮","按钮四","按钮五","按钮六","按钮七","按钮八","按钮九","按钮十","按钮十一","按钮十二","按钮十三"]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentView = JWSegmentMenuView(frame: CGRectMake(0, 20, self.view.frame.size.width, 33))
        segmentView?.titlesArray = titlesArray
        segmentView?.segmentMenuViewDelegate = self
        self.view.addSubview(segmentView!)
    }
    
    //MARK: - JWSegmentMenuViewDelegate
    func selectItem(index: Int) {
        textLabel.text = titlesArray[index]
    }
}

