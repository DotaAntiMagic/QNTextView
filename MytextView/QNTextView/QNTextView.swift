//
//  QNTextView.swift
//  MytextView
//
//  Created by 祁宁 on 16/6/22.
//  Copyright © 2016年 祁宁. All rights reserved.
//

import UIKit

@IBDesignable public class QNTextView: UITextView,UIScrollViewDelegate {
    
  @IBInspectable public var placeholderText:String? // placeholder文字信息
  @IBInspectable public var placeholderColor:UIColor? // placeholder文字颜色
  @IBInspectable public var maxInputLength:NSInteger = 0 // 最大输入文字数量
   public var showInputting:Bool = false // 是否右下角显示输入提醒，默认为NO
   private var _placeholderLabel:UILabel!
   private var _inputtingLabel:UILabel!
    
    convenience init() {
        self.init(frame: CGRectZero)
        self.setup()
    }

    override  public func awakeFromNib() {
        self.setup()
    }
    
    override  public func layoutSubviews() {
        super.layoutSubviews()
        self.configPlaceholderLabel()
        self.configInputtingLabel()
    }
    
    func setup()  {
        self.font = UIFont.systemFontOfSize(13)
        self.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
        if (placeholderColor == nil) {
          placeholderColor = UIColor.lightGrayColor()
        }
        if  (placeholderText == nil) {
            placeholderText = ""
        }
        if  ( 0 == maxInputLength) {
            maxInputLength = NSInteger(INT_MAX)
        }
        _placeholderLabel = UILabel.init(frame: CGRectMake(0, 0, self.bounds.size.width, 50))
        self.addSubview(_placeholderLabel)
        self.sendSubviewToBack(_placeholderLabel)
        
        _inputtingLabel = UILabel.init(frame: CGRectMake(0, 0, self.bounds.size.width, 50))
        self.addSubview(_inputtingLabel)
        self.sendSubviewToBack(_inputtingLabel)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textChanged(_:)), name: UITextViewTextDidChangeNotification, object: nil)
        self.updatePlaceholderLabel()
        self.updateInputtingLabel()
        }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func textChanged(notification:NSNotification)   {
        if (self.text.characters.count >= maxInputLength) {
          self.text = (self.text as NSString).substringToIndex(maxInputLength)
        }
        self.updateInputtingLabel()
        if self.placeholderText?.characters.count == 0 {
            return
        }
        self.updatePlaceholderLabel()
    }
    
    func updateInputtingLabel()  {
        
        // 问题
       _inputtingLabel.hidden = !showInputting
        
        if NSInteger(INT_MAX) == maxInputLength {
            return
        }
        _inputtingLabel.text = "\(self.text.characters.count)/\(maxInputLength)"
      
    }

    func updatePlaceholderLabel()  {
        if (self.text.characters.count > 0)  {
            if(_placeholderLabel.hidden == false){
            UIView.animateWithDuration(0.1, animations: { 
                self._placeholderLabel.alpha = 0.0
                }, completion: { (finished:Bool) in
                    self._placeholderLabel.hidden = true
            })
        }
        } else {
           self.configPlaceholderLabel()
            _placeholderLabel.hidden = false
            _placeholderLabel.alpha = 0.0
            UIView.animateWithDuration(0.1, animations: { 
                self._placeholderLabel.alpha = 1.0
                }, completion: { (finished:Bool) in
            })
        }
    }
    
    func configPlaceholderLabel(){
        _placeholderLabel.lineBreakMode =  NSLineBreakMode.ByWordWrapping
        _placeholderLabel.numberOfLines = 0
        _placeholderLabel.font = self.font
        _placeholderLabel.backgroundColor = UIColor.clearColor()
        _placeholderLabel.textColor = self.placeholderColor
        _placeholderLabel.text = self.placeholderText
        _placeholderLabel.textAlignment = NSTextAlignment.Left
        _placeholderLabel.sizeToFit()
        var rect:CGRect = self.placeholderRectForBounds(self.bounds)
        rect.size.height = _placeholderLabel.frame.size.height
        _placeholderLabel.frame = rect;
        
    }
    
    func placeholderRectForBounds(bounds:CGRect) -> CGRect {
        var rect:CGRect = UIEdgeInsetsInsetRect(bounds, self.contentInset)
        if (self.respondsToSelector(Selector("textContainer"))) {
            rect = UIEdgeInsetsInsetRect(rect, self.textContainerInset)
            let padding:CGFloat = self.textContainer.lineFragmentPadding
            rect.origin.x+=padding
            rect.size.width-=padding * 2.0
        } else {
            if self.contentInset.left == 0.0 {
                rect.origin.x+=8.0
            }
        }
        return rect
    }
    
    func configInputtingLabel() {
        _inputtingLabel.numberOfLines = 1
        _inputtingLabel.font = self.font
        _inputtingLabel.backgroundColor = UIColor.clearColor()
        _inputtingLabel.textColor = self.placeholderColor
        _inputtingLabel.text = "\(self.text.characters.count)/\(maxInputLength)"
        _inputtingLabel.textAlignment = NSTextAlignment.Right
        _inputtingLabel.frame = CGRectMake(0, self.contentOffset.y+self.bounds.size.height-self.font!.lineHeight, self.bounds.size.width - 8, self.font!.lineHeight)
    }
    
    public func setCursorToEnd() {
        let length = self.text.characters.count
        self.selectedRange = NSMakeRange(length, 0)
    }
    
    
}

