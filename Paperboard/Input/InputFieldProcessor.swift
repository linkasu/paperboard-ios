//
//  InputFieldProcessor.swift
//  Paperboard
//
//  Created by Andrey Tchernov on 17.08.2018.
//  Copyright © 2018 Ice Rock. All rights reserved.
//

import UIKit

class InputFieldProcessor: NSObject, UITextFieldDelegate {
  var onUpdate: ((String) -> Void)?
  
  private (set) var currentValue: String = "" {
    didSet {
      onUpdate?(currentValue)
    }
  }
  
  func appendLetter(_ letter: String) {
    currentValue.append(letter)
  }
  
  func clear() {
    currentValue = ""
  }
  
  func backSpace() {
    currentValue = String(currentValue.dropLast())
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return false
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    textField.inputView = UIView(frame: CGRect.zero)
    textField.inputAccessoryView = UIView(frame: CGRect.zero)
    textField.inputAssistantItem.leadingBarButtonGroups.removeAll()
    textField.inputAssistantItem.trailingBarButtonGroups.removeAll()
    return true
  }
  
}
