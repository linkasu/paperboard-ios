//
//  SettingsSplitViewController.swift
//  Paperboard
//
//  Created by Igor Zapletnev on 09.03.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import Foundation
import UIKit

class SettingsSplitViewController: UISplitViewController {
    var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        preferredDisplayMode = .oneBesideSecondary
        
        let masterViewNavController = viewControllers.first as? UINavigationController
        if let masterViewController = masterViewNavController?.viewControllers.first as? SettingsMasterViewController {
            masterViewController.settings = settings
        }
    }
}
