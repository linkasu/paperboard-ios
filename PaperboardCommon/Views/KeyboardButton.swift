//
//  KeyboardButton.swift
//  Paperboard
//
//  Created by Igor Zapletnev on 13.12.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import UIKit

class KeyboardButton: UIButton {
    var defaultBackgroundColor: UIColor = .white
    var highlightBackgroundColor: UIColor = .lightGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = isHighlighted ? highlightBackgroundColor : defaultBackgroundColor
    }
    
    func commonInit() {
        let isCompact = UIDevice.current.userInterfaceIdiom == .phone
        layer.cornerRadius = isCompact ? 5.0 : 8.0
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 0.0
        layer.shadowOpacity = 0.3
        
        imageView?.contentMode = .scaleAspectFit
        
        updateFont()
    }
    
    func updateFont() {
        let isCompact = UIDevice.current.userInterfaceIdiom == .phone
        if let titleLabel = titleLabel {
            let originalFontSize = titleLabel.font.pointSize
            titleLabel.font = titleLabel.font.withSize(isCompact ? originalFontSize/2 : originalFontSize)
        }
    }
    
    func configure(colorScheme: PaperboardColors, buttonColors: ButtonColors) {
        setTitleColor(colorScheme.textColor, for: [])
        tintColor = colorScheme.textColor
        
        defaultBackgroundColor = buttonColors.backgroundColor
        highlightBackgroundColor = buttonColors.highlightColor
    }
}
