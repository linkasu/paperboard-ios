//
//  KeyboardViewController.swift
//  Paperboard
//
//  Created by Igor Zapletnev on 08.03.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import Foundation
import UIKit

class KeyboardViewController: UIViewController {
    override func viewDidLoad() {
        self.navigationItem.title = PaperboardLocalizable.settingsKeyboard.message()
        super.viewDidLoad()
    }
}
