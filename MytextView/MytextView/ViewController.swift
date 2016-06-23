//
//  ViewController.swift
//  MytextView
//
//  Created by 祁宁 on 16/6/22.
//  Copyright © 2016年 祁宁. All rights reserved.
//

import UIKit
import QNTextView

class ViewController: UIViewController {
let textView = QNTextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.frame = CGRectMake(20, 20, 300, 300)
        textView.placeholderText = "111"
        textView.placeholderColor = UIColor.redColor()
        textView.maxInputLength = 110
        textView.showInputting = true
       self.view.addSubview(textView)
        
    }


    @IBAction func Buttonaction(sender: AnyObject) {

        textView.setCursorToEnd()
    }

   

}

