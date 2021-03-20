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

struct ButtonColors {
    let backgroundColor: UIColor
    let highlightColor: UIColor
}

struct PaperboardColors {
    let textColor: UIColor
    let backgroundColor: UIColor?
    
    let main: ButtonColors
    let control: ButtonColors
    let system: ButtonColors
    let focus: ButtonColors
    
    init(colorScheme: PaperboardColorScheme) {
        switch colorScheme {
        case .light:
            textColor = .black
            backgroundColor = UIColor(red: 210/255, green: 213/255, blue: 219/255, alpha: 1.0)
            
            main = ButtonColors(
                backgroundColor: UIColor(hex: "#FCFCFE"),
                highlightColor: UIColor(hex: "#F5F5F5")
            )
            
            control = ButtonColors(
                backgroundColor: UIColor(hex: "#F0F0F0"),
                highlightColor: UIColor(hex: "#E2E4E4")
            )
            
            system = ButtonColors(
                backgroundColor: UIColor(hex: "#AEB3BE"),
                highlightColor: UIColor(hex: "#8E95A4")
            )
            
            focus = ButtonColors(
                backgroundColor: UIColor(hex: "#0F77F0"),
                highlightColor: UIColor(hex: "#0E6DDD")
            )
            
        case .dark:
            textColor = .white
            backgroundColor = UIColor(hex: "#686868")
            
            main = ButtonColors(
                backgroundColor: UIColor(hex: "#525252"),
                highlightColor: UIColor(hex: "#525252")
            )
            
            control = ButtonColors(
                backgroundColor: UIColor(hex: "#3F3F3F"),
                highlightColor: UIColor(hex: "#3F3F3F")
            )
            
            system = ButtonColors(
                backgroundColor: UIColor(hex: "#3F3F3F"),
                highlightColor: UIColor(hex: "#3F3F3F")
            )
            
            focus = ButtonColors(
                backgroundColor: UIColor(hex: "#0F77F0"),
                highlightColor: UIColor(hex: "#0075EB")
            )
        }
    }
}
