//
//  UIView+Spacing.swift
//  Paperboard
//
//  Created by Igor Zapletnev on 14.03.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import UIKit
extension UIView {
    func configureSpacing(spacing: Int) {
        superview?.constraints.forEach { constaint in
            configureSpacing(constaint: constaint, anchor: bottomAnchor, spacing: spacing)
            configureSpacing(constaint: constaint, anchor: topAnchor, spacing: spacing)
            configureSpacing(constaint: constaint, anchor: leadingAnchor, spacing: spacing)
            configureSpacing(constaint: constaint, anchor: trailingAnchor, spacing: spacing)
        }
    }
    
    func configureSpacing<T>(constaint: NSLayoutConstraint, anchor: NSLayoutAnchor<T>, spacing: Int) {
        if constaint.secondAnchor == anchor || constaint.firstAnchor == anchor {
            if constaint.constant != 0 {
                constaint.constant = CGFloat(spacing)
            }
        }
    }
}
