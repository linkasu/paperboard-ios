//
//  InputFieldProcessor.swift
//  Paperboard
//
//  Created by Andrey Tchernov on 17.08.2018.
//  Copyright © 2018 Ice Rock. All rights reserved.
//

import UIKit

class InputFieldProcessor: NSObject {
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

}
