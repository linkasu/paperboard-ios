//
//  NSLayoutConstraint.swift
//  Paperboard
//
//  Created by Igor Zapletnev on 04.03.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import UIKit

public extension NSLayoutConstraint {
    
    func changeMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        newConstraint.priority = priority
        
        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
    
}
