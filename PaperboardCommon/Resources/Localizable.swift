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
    
    func message() -> String {
        return NSLocalizedString(rawValue, comment: "")
    }
}
