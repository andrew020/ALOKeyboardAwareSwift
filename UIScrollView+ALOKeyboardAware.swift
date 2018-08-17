//
//  UIScrollView+ALOKeyboardAware.swift
//  Example
//
//  Created by 李宗良 on 2018/8/15.
//  Copyright © 2018年 Andrew.Leo. All rights reserved.
//

import UIKit

extension UIScrollView {
    var alo_autoResizeContent: Bool {
        set {
            if newValue == alo_autoResizeContent {
                return
            }
            if newValue == true {
                addNotification()
                alo_autoScrollFirstResponder = false
            }
            else {
                removeNotification()
                alo_autoScrollFirstResponder = false
            }
            objc_setAssociatedObject(self, safeKey("kAOLKeyboardAwareAutoResizeContent"), newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, safeKey("kAOLKeyboardAwareAutoResizeContent")) as? Bool ?? false
        }
    }
    
    var alo_autoScrollFirstResponder: Bool {
        set {
            objc_setAssociatedObject(self, "kAOLKeyboardAwareAutoScrollFirstResponder", newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, safeKey("kAOLKeyboardAwareAutoScrollFirstResponder")) as? Bool ?? false
        }
    }
    
    private func safeKey(_ key: String!) -> UnsafeRawPointer! {
        return UnsafeRawPointer.init(bitPattern: key.hashValue)
    }
}

extension UIScrollView {
    private var alo_initialContentInset: NSValue? {
        set {
            objc_setAssociatedObject(self, safeKey("kAOLKeyboardAwareInitialContentInset"), newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, safeKey("kAOLKeyboardAwareInitialContentInset")) as? NSValue
        }
    }
    
    private func addNotification() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func removeNotification() -> Void {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil);
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil);
    }
    
    // MARK: Keyboard Notification Response
    @objc private func keyboardWillShow(notification: Notification!) -> Void {
        if alo_initialContentInset == nil {
            let contentInsetValue = NSValue(uiEdgeInsets: contentInset)
            alo_initialContentInset = contentInsetValue
        }
        let initialContentInset = alo_initialContentInset!.uiEdgeInsetsValue
        
        let userInfo = notification.userInfo!
        let rectValue: NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let timeInterval = Double(truncating: userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber)
        let keyboardRect = rectValue.cgRectValue
        
        let window = UIApplication.shared.keyWindow
        let scrollRectInWindow = convert(bounds, to: window)
        
        let maxYOfScrollView = scrollRectInWindow.maxY
        var newContentInset = initialContentInset
        if maxYOfScrollView > keyboardRect.origin.y {
            let bottomEdge = maxYOfScrollView - keyboardRect.origin.y
            newContentInset.bottom += bottomEdge
        }
        if UIEdgeInsetsEqualToEdgeInsets(contentInset, newContentInset) == true {
            return
        }
        
        let currentFirstResponder = UIResponder.alo_currentFirstResponder()
        let moveResponder = alo_autoScrollFirstResponder && (currentFirstResponder != nil)
        var rectOfFirstResponderInScrollView = CGRect.zero
        if moveResponder == true {
            rectOfFirstResponderInScrollView = currentFirstResponder!.convert(currentFirstResponder!.bounds, to: window)
        }
        UIView.animate(withDuration: timeInterval) { [weak self] in
            self?.contentInset = newContentInset
            if moveResponder == true {
                self?.scrollRectToVisible(rectOfFirstResponderInScrollView, animated: false)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification!) -> Void {
        if let newContentInset = alo_initialContentInset?.uiEdgeInsetsValue {
            let timeInterval = Double(truncating: notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber)
            if UIEdgeInsetsEqualToEdgeInsets(self.contentInset, newContentInset) == false {
                UIView.animate(withDuration: timeInterval) { [weak self] in
                    self?.contentInset = newContentInset;
                }
            }
        }
        alo_initialContentInset = nil;
    }
}
