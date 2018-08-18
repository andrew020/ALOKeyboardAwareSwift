//
//  UIResponder+ALOFirstResponder.swift
//  Example
//
//  Created by 李宗良 on 2018/8/15.
//  Copyright © 2018年 Andrew.Leo. All rights reserved.
//

import UIKit

extension UIResponder {
    static weak var alo_currentFirstResponderObject: AnyObject?;
    
    class func alo_currentFirstResponder() -> UIView? {
        UIResponder.alo_currentFirstResponderObject = nil;
        // 通过将target设置为nil，让系统自动遍历响应链
        // 从而响应链当前第一响应者响应我们自定义的方法
        UIApplication.shared.sendAction(#selector(alo_findFirstResponder(sender:)), to: nil, from: nil, for: nil);
        return UIResponder.alo_currentFirstResponderObject as? UIView;
    }
    
    @objc private func alo_findFirstResponder(sender: AnyObject?) -> Void {
        UIResponder.alo_currentFirstResponderObject = self;
    }
}
