//
//  Localizable.swift
//  Paperboard
//
//  Created by Igor Zapletnev on 04.03.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import Foundation
import UIKit

enum PaperboardLocalizable: String {
    case clear = "input.clear"
    case talk = "input.talk"
    case go = "keyboard.go"
    case search = "keyboard.search"
    case `continue` = "keyboard.continue"
    case `return` = "keyboard.return"
    case settingsTitle = "settings.title"
    case settingsColumns = "settings.columns.title"
    case settingsKeyboard = "settings.dialog.keyboard"
    
    func message() -> String {
        return NSLocalizedString(rawValue, comment: "")
    }
}
