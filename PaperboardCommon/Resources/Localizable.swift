//
//  Localizable.swift
//  Paperboard
//
//  Created by Igor Zapletnev on 04.03.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import Foundation
import UIKit

enum PaperboardMessages: String {
    // input
    case clear = "input.clear"
    case talk = "input.talk"
    case alphabet = "input.alphabet"
    case done = "input.done"
    case space = "input.space"
    
    // keyboard
    case go = "keyboard.go"
    case search = "keyboard.search"
    case `continue` = "keyboard.continue"
    case `return` = "keyboard.return"
    
    // settings
    case settingsTitle = "settings.title"
    case settingsColumns = "settings.columns.title"
    case settingsKeyboard = "settings.dialog.keyboard"
    case settingsKeyboardUnknownLanguage = "settings.keyboard.unknownLanguage"
    case settingKeyboardDefault = "settings.keyboard.default"
    
    var text: String {
        return NSLocalizedString(rawValue, comment: "")
    }
}
