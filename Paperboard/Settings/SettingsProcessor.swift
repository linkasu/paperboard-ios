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
    
    let settingsAlert = UIAlertController(title: NSLocalizedString("settings.title", comment: ""), message: nil, preferredStyle: .actionSheet)
    
    settingsAlert.addAction(
      UIAlertAction(
        title: NSLocalizedString("settings.dialog.columns", comment: ""),
        style: .default,
        handler: { _ in
          self.showColumnsSetting(onController: controller)
      })
    )
    
    settingsAlert.addAction(
      UIAlertAction(
        title: NSLocalizedString("settings.dialog.cancel", comment: ""),
        style: .cancel,
        handler: nil
      )
    )
    
    settingsAlert.popoverPresentationController?.barButtonItem = barButton
    controller.present(settingsAlert, animated: true, completion: nil)
  }
  
  private func showColumnsSetting(onController controller: UIViewController) {
    SetColumnsViewController.push(from: controller, withChangesCallback: onColumnAmountChanged)
  }
}
