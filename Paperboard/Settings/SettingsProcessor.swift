//
//  SettingsProcessor.swift
//  Paperboard
//
//  Created by Andrey Tchernov on 17.08.2018.
//  Copyright © 2018 Ice Rock. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class SettingsProcessor: NSObject {
  
  var onColumnAmountChanged: ((Int) -> Void)?
  var onKeyboardChanged: ((Keyboard) -> Void)?
  
  private let storage = SettingsStorage()
  
  private var keyboards: [Keyboard] = {
    let decoder = PropertyListDecoder()
    guard let plist = Bundle.main.url(forResource: "Keyboards", withExtension: "plist"),
      let data = try? Data(contentsOf: plist),
      let keyboards = try? decoder.decode([Keyboard].self, from: data) else {
        return []
    }
    return keyboards
  }()
  
  var currentColumns: Int {
    get {
      return (storage.getSettingValue(.columns) as? NSNumber)?.intValue ?? 3
    }
    set {
      storage.update(.columns, withValue: NSNumber(integerLiteral: newValue))
      onColumnAmountChanged?(newValue)
    }
  }
  
  var currentKeyboard: Keyboard? {
    get {
      guard let locale = storage.getSettingValue(.locale) as? String else {
        return nil
      }
      return keyboards.first(where: { $0.locale == locale })
    }
    set {
      storage.update(.columns, withValue: newValue?.locale)
      if let nKeyboard = newValue {
        onKeyboardChanged?(nKeyboard)
      }
    }
  }
  
  func showSettings(onController controller: UIViewController, byBarButton barButton: UIBarButtonItem) {
    
    let settingsAlert = UIAlertController(title: NSLocalizedString("settings.title", comment: ""), message: nil, preferredStyle: .actionSheet)
    settingsAlert.view.tintColor = #colorLiteral(red: 0.9843137255, green: 0.8, blue: 0.1882352941, alpha: 1)
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
        title: NSLocalizedString("Localize me: settings.dialog.keyboard", comment: ""),
        style: .default,
        handler: { _ in
          self.showKeyboardSettings(atBarButton: barButton)
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
  
  private func showKeyboardSettings(atBarButton barButton: UIBarButtonItem) {
    guard !keyboards.isEmpty else {
      //TODO: show errors
      return
    }
    let index = keyboards.index(where: { $0.locale == currentKeyboard?.locale }) ?? 0
    let picker = ActionSheetStringPicker(
      title: "Localize me: settings.keyboard.title",
      rows: keyboards.map({ "\($0.voiceName) - \(NSLocale.current.localizedString(forLanguageCode: $0.locale) ?? "Localize me: settings.keyboard.unknownLanguage")" }),
      initialSelection: index,
      doneBlock: { (picker, newIndex, newValue) in
        self.currentKeyboard = self.keyboards[newIndex]
    },
      cancel: { _ in },
      origin: barButton)
    picker?.popoverDisabled = true
    picker?.show()
    //controller.present(picker, animated: true, completion: nil)
  }
  
  private func showColumnsSetting(onController controller: UIViewController) {
    let setColumnsVC = SetColumnsViewController.create()
    setColumnsVC.initialValue = currentColumns
    setColumnsVC.onAmountChanges = { newValue in
      self.currentColumns = newValue
    }
    controller.present(setColumnsVC, animated: false, completion: nil)
  }
  
  struct Keyboard: Decodable {
    let voiceId: String
    let voiceName: String
    let alphabet: String
    let rightToLeft: Bool
    let locale: String
  }
}
