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
            
            mainButtonBackgroundColor = UIColor(red: 252/255, green: 252/255, blue: 254/255, alpha: 1.0)
            mainButtonHighlightColor = mainButtonBackgroundColor.withAlphaComponent(0.8)
            
            controlButtonBackgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
            controlButtonHighlightColor = controlButtonBackgroundColor.withAlphaComponent(0.8)
            
            systemButtonBackgroundColor = UIColor(red: 174/255, green: 179/255, blue: 190/255, alpha: 1.0)
            systemButtonHighlightColor = systemButtonBackgroundColor.withAlphaComponent(0.8)
            
            focusButtonBackgroundColor = UIColor(red: 15/255, green: 119/255, blue: 240/255, alpha: 1.0)
            focusButtonHighlightColor = focusButtonBackgroundColor.withAlphaComponent(0.8)
            
            backgroundColor = UIColor(red: 210/255, green: 213/255, blue: 219/255, alpha: 1.0)
            previewTextColor = .white
            previewBackgroundColor = UIColor(red: 186/255, green: 191/255, blue: 200/255, alpha: 1.0)
        case .dark:
            buttonTextColor = .white
            
            mainButtonBackgroundColor = UIColor(white: 138/255, alpha: 1.0)
            mainButtonHighlightColor = UIColor(white: 104/255, alpha: 1.0)
            
            controlButtonBackgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
            controlButtonHighlightColor = controlButtonBackgroundColor.withAlphaComponent(0.8)
            
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
