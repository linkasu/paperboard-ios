//
//  KeyboardViewController.swift
//  PaperboardKeyboard
//
//  Created by Igor Zapletnev on 08.12.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    private let keyboardViewContoller = MainKeyboardViewController()
    
    private var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightConstraint = self.view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.7)
        heightConstraint.isActive = true
        
        self.addChild(keyboardViewContoller)
        self.view.addSubview(keyboardViewContoller.view)
        keyboardViewContoller.view.translatesAutoresizingMaskIntoConstraints = false
        keyboardViewContoller.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        keyboardViewContoller.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        keyboardViewContoller.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        keyboardViewContoller.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        keyboardViewContoller.inputProcessor = InputKeyboardProcessor(
            documentProxy: textDocumentProxy
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        handleRotation()
        keyboardViewContoller.inputCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func handleRotation() {
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            keyboardViewContoller.buttonsStackViews.forEach { $0.axis = .horizontal }
            heightConstraint.constant = UIScreen.main.bounds.height * 0.7
        } else {
            keyboardViewContoller.buttonsStackViews.forEach { $0.axis = .vertical }
            heightConstraint.constant = UIScreen.main.bounds.height * 0.7
        }
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        switch textDocumentProxy.keyboardAppearance {
        case .dark:
            keyboardViewContoller.setColorScheme(.dark)
        case .light:
            keyboardViewContoller.setColorScheme(.light)
        default:
            break
        }
    }
}
