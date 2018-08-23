//
//  SettingsManager.swift
//  Paperboard
//
//  Created by Andrey Tchernov on 17.08.2018.
//  Copyright © 2018 Ice Rock. All rights reserved.
//

import Foundation

class SettingsManager: NSObject {
  private let defaults = UserDefaults.standard
  
  enum Settings: String {
    case columns
    
    fileprivate var defaultsKey: String {
      get {
        return "settings.\(self.rawValue)"
      }
    }
  }
  
  func update(_ setting: Settings, withValue value: Any?) {
    defaults.set(value, forKey: setting.defaultsKey)
    defaults.synchronize()
  }
  
  func getSettingValue(_ setting: Settings) -> Any? {
    return defaults.object(forKey: setting.defaultsKey)
  }
}
