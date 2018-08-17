//
//  SettingsProcessor.swift
//  Paperboard
//
//  Created by Andrey Tchernov on 17.08.2018.
//  Copyright © 2018 Ice Rock. All rights reserved.
//

import UIKit

class SettingsProcessor: NSObject {
  var onColumnAmountChanged: ((Int) -> Void)?
  func showSettings(onController controller: UIViewController, byBarButton barButton: UIBarButtonItem) {
    SetColumnsViewController.push(from: controller, withChangesCallback: onColumnAmountChanged)
  }
}
