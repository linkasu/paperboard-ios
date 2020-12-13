//
//  InputKeyboardProcessor.swift
//  PaperboardKeyboard
//
//  Created by Igor Zapletnev on 13.12.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import UIKit

class InputKeyboardProcessor: InputProcessor {
    private var caps = false
    
    weak var documentProxy: UITextDocumentProxy!
    
    init(documentProxy: UITextDocumentProxy) {
        self.documentProxy = documentProxy
    }
    
    func getText() -> String {
        return (documentProxy.documentContextBeforeInput ?? "") + (documentProxy.documentContextAfterInput ?? "")
    }
    
    func append(text: String) {
        documentProxy.insertText(caps ? text.capitalized : text)
    }
    
    func clear() {
        if let afterInput = documentProxy.documentContextAfterInput {
            documentProxy.adjustTextPosition(byCharacterOffset: afterInput.count)
        }
        while let _ = documentProxy.documentContextBeforeInput {
            documentProxy.deleteBackward()
        }
    }
    
    func backspace() {
        documentProxy.deleteBackward()
    }
    
    func capsLock() {
        caps = !caps
    }
    
    func isCaps() -> Bool {
        return caps
    }
}
