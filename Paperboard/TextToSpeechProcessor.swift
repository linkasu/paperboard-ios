//
//  TextToSpeechProcessor.swift
//  Paperboard
//
//  Created by Andrey Tchernov on 17.08.2018.
//  Copyright © 2018 Ice Rock. All rights reserved.
//

import Foundation
import AVFoundation

class TextToSpeechProcessor: NSObject {
  
  private let synthesizer = AVSpeechSynthesizer()
  
  override init() {
    super.init()
    print(AVSpeechSynthesisVoice.speechVoices().map({ "\($0.identifier) - \($0.name) - \($0.language)" }).joined(separator: "\n"))
  }
  
  func speechText(_ text: String) {
    synthesizer.speak(AVSpeechUtterance.init(string: text))
  }
}
