//
//  Styles.swift
//  Paperboard
//
//  Created by Igor Zapletnev on 13.12.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import UIKit

enum PaperboardColorScheme {
    case dark
    case light
}

struct PaperboardColors {
    let buttonTextColor: UIColor
    let mainButtonBackgroundColor: UIColor
    let mainButtonHighlightColor: UIColor
    let controlButtonBackgroundColor: UIColor
    let controlButtonHighlightColor: UIColor
    let systemButtonBackgroundColor: UIColor
    let systemButtonHighlightColor: UIColor
    let focusButtonBackgroundColor: UIColor
    let focusButtonHighlightColor: UIColor
    let backgroundColor: UIColor
    let previewTextColor: UIColor
    let previewBackgroundColor: UIColor
    
    init(colorScheme: PaperboardColorScheme) {
        switch colorScheme {
        case .light:
            buttonTextColor = .black
            
            mainButtonBackgroundColor = UIColor(hex: "#FCFCFE")
            mainButtonHighlightColor = UIColor(hex: "#F5F5F5")
            
            controlButtonBackgroundColor = UIColor(hex: "#F0F0F0")
            controlButtonHighlightColor = UIColor(hex: "#E2E4E4")
            
            systemButtonBackgroundColor = UIColor(hex: "#AEB3BE")
            systemButtonHighlightColor = UIColor(hex: "#8E95A4")
            
            focusButtonBackgroundColor = UIColor(hex: "#0F77F0")
            focusButtonHighlightColor = UIColor(hex: "#0E6DDD")
            
            backgroundColor = UIColor(red: 210/255, green: 213/255, blue: 219/255, alpha: 1.0)
            previewTextColor = .white
            previewBackgroundColor = UIColor(red: 186/255, green: 191/255, blue: 200/255, alpha: 1.0)
        case .dark:
            buttonTextColor = .white
            
            mainButtonBackgroundColor = UIColor(hex: "#646464")
            mainButtonHighlightColor = UIColor(hex: "#525252")
            
            controlButtonBackgroundColor = UIColor(hex: "#3F3F3F")
            controlButtonHighlightColor = UIColor(hex: "#242424")
            
            systemButtonBackgroundColor = UIColor(red: 174/255, green: 179/255, blue: 190/255, alpha: 1.0)
            systemButtonHighlightColor = systemButtonBackgroundColor.withAlphaComponent(0.8)
            
            focusButtonBackgroundColor = UIColor(red: 15/255, green: 119/255, blue: 240/255, alpha: 1.0)
            focusButtonHighlightColor = focusButtonBackgroundColor.withAlphaComponent(0.8)
            
            backgroundColor = UIColor(white:89/255, alpha: 1.0)
            previewTextColor = .white
            previewBackgroundColor = UIColor(white: 80/255, alpha: 1.0)
        }
    }
}
