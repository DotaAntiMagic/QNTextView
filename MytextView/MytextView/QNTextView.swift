//
//  QNTextView.swift
//  MytextView
//
//  Created by 祁宁 on 16/6/22.
//  Copyright © 2016年 祁宁. All rights reserved.
//

import UIKit

//private extension String{
//    func naturalTextAligment() -> NSTextAlignment{
//        if (self.characters.count == 0){
//            return NSTextAlignment.Natural
//        }
//        let tagschemes:NSArray = [NSLinguisticTagSchemeLanguage]
//        let tagger:NSLinguisticTagger = NSLinguisticTagger.init(tagSchemes: tagschemes as! [String], options: 0)
//        tagger.string = self
//        let language:String = tagger.tagAtIndex(0, scheme: NSLinguisticTagSchemeLanguage, tokenRange: nil, sentenceRange: nil)!
//        if (language.rangeOfString("he")?.startIndex != nil || language.rangeOfString("ar")?.startIndex != nil) {
//            return NSTextAlignment.Right
//        } else {
//            return NSTextAlignment.Left
//        }
//    }
//}

 class QNTextView: UITextView,UIScrollViewDelegate {
    
    var placeholderText:String? // placeholder文字信息
    var placeholderColor:UIColor? // placeholder文字颜色
    var maxInputLength:NSInteger = 0 // 最大输入文字数量
    var showInputting:Bool? // 是否右下角显示输入提醒，默认为NO
    var _placeholderLabel:UILabel!
    var _inputtingLabel:UILabel!
    var oldtext: String? {  // 问题
        willSet(newText){
            self._updatePlaceholderLabel()
            self._updateInputtingLabel()
        }
    }
    var oldShowInPutting:Bool? {
        willSet(newShowInPutting){
            showInputting = newShowInPutting
            self._updateInputtingLabel()
        }
    }
    var oldPlaceholder:String? {
        willSet(newPlaceholder) {
            if(newPlaceholder == placeholderText) {
                return
            }
            placeholderText = newPlaceholder
            self._updatePlaceholderLabel()
        }
    }
    var oldContentInset:UIEdgeInsets? {
        willSet(newContentInset){  // 问题
            self._updatePlaceholderLabel()
        }
    }
    var oldFont:UIFont? {
        willSet(NewFont) {
        self._updatePlaceholderLabel()
        }
        
    }
    var oldTextAlignment:NSTextAlignment? {
        willSet(newTextAlignment) {
            self._updatePlaceholderLabel()
        }
    
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
        self._setup()
    }
//    override init(frame: CGRect){
//        super.init(frame: frame)
//        self._setup()
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    override  func awakeFromNib() {
        self._setup()
    }
    
    override  func layoutSubviews() {
        super.layoutSubviews()
        self._configPlaceholderLabel()
        self._configInputtingLabel()
    }
    
    func _setup()  {
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
        self._updatePlaceholderLabel()
        self._updateInputtingLabel()
        }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func textChanged(notification:NSNotification)   {
        if (self.text.characters.count >= maxInputLength) {
          self.text = (self.text as NSString).substringToIndex(maxInputLength)
        }
        self._updateInputtingLabel()
        if self.placeholderText?.characters.count == 0 {
            return
        }
        self._updatePlaceholderLabel()
    }
    
    func _updateInputtingLabel()  {
        
        // 问题
        if showInputting == nil {
            return
        }else {
        _inputtingLabel.hidden = !showInputting!
        }
        
        if NSInteger(INT_MAX) == maxInputLength {
            return
        }
  
        _inputtingLabel.text = "\(self.text.characters.count)/\(maxInputLength)"
      
    }

    func _updatePlaceholderLabel()  {
        if (self.text.characters.count > 0)  {
            if(_placeholderLabel.hidden == false){
            UIView.animateWithDuration(0.1, animations: { 
                self._placeholderLabel.alpha = 0.0
                }, completion: { (finished:Bool) in
                    self._placeholderLabel.hidden = true
            })
        }
        } else {
           self._configPlaceholderLabel()
            _placeholderLabel.hidden = false
            _placeholderLabel.alpha = 0.0
            UIView.animateWithDuration(0.1, animations: { 
                self._placeholderLabel.alpha = 1.0
                }, completion: { (finished:Bool) in
            })
        }
    }
    
    func _configPlaceholderLabel(){
        _placeholderLabel.lineBreakMode =  NSLineBreakMode.ByWordWrapping
        _placeholderLabel.numberOfLines = 0
        _placeholderLabel.font = self.font
        _placeholderLabel.backgroundColor = UIColor.clearColor()
        _placeholderLabel.textColor = self.placeholderColor
        _placeholderLabel.text = self.placeholderText
        _placeholderLabel.textAlignment = NSTextAlignment.Left
        _placeholderLabel.sizeToFit()
        var rect:CGRect = self._placeholderRectForBounds(self.bounds)
        rect.size.height = _placeholderLabel.frame.size.height
        _placeholderLabel.frame = rect;
        
    }
    
    func _placeholderRectForBounds(bounds:CGRect) -> CGRect {
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
    
    func _configInputtingLabel() {
        _inputtingLabel.numberOfLines = 1
        _inputtingLabel.font = self.font
        _inputtingLabel.backgroundColor = UIColor.clearColor()
        _inputtingLabel.textColor = self.placeholderColor
        _inputtingLabel.text = "\(self.text.characters.count)/\(maxInputLength)"
        _inputtingLabel.textAlignment = NSTextAlignment.Right
        _inputtingLabel.frame = CGRectMake(0, self.contentOffset.y+self.bounds.size.height-self.font!.lineHeight, self.bounds.size.width - 8, self.font!.lineHeight)
    }
    
     func setCursorToEnd() {
        let length = self.text.characters.count
        self.selectedRange = NSMakeRange(length, 0)
    }
    
    
}

