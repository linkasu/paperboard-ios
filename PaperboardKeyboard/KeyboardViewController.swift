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
    private let keyboardHeight: CGFloat = 0.6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newHeight = UIScreen.main.bounds.height * keyboardHeight
        heightConstraint = self.view.heightAnchor.constraint(equalToConstant: newHeight)
        
        keyboardViewContoller.inputLayout.spacing = 8
        
        heightConstraint.isActive = true
        
        self.addChild(keyboardViewContoller)
        self.view.addSubview(keyboardViewContoller.view)
        keyboardViewContoller.view.translatesAutoresizingMaskIntoConstraints = false
        keyboardViewContoller.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        keyboardViewContoller.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        keyboardViewContoller.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        keyboardViewContoller.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        keyboardViewContoller.inputProcessor = InputKeyboardProcessor(
            inputView: self,
            documentProxy: textDocumentProxy
        )
        
        keyboardViewContoller.isClearSystem = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        keyboardViewContoller.actionButton?.setTitle(returnName().text, for: .normal)
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.keyboardViewContoller.inputLayout.invalidateLayout()
    }
    
    func handleRotation() {
        let newHeight = UIScreen.main.bounds.height * keyboardHeight
        heightConstraint.constant = newHeight
        
        keyboardViewContoller.inputCollectionView.reloadData()
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        keyboardViewContoller.setColorScheme(getColorScheme())
    }
    
    func getColorScheme() -> PaperboardColorScheme {
        switch textDocumentProxy.keyboardAppearance {
        case .dark:
            return .dark
        case .light:
            return .light
        default:
            if #available(iOS 12.0, *) {
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return .dark
                case .light:
                    return .light
                default:
                    return .light
                }
            }
            return .light
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(
            alongsideTransition: nil,
            completion: { [weak self] _ in
                self?.handleRotation()
                self?.keyboardViewContoller.inputCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
            })
    }
    
    func returnName() -> PaperboardMessages {
        switch textDocumentProxy.returnKeyType {
        case .go:
            return PaperboardMessages.go
        case .yahoo:
            return PaperboardMessages.search
        case .google:
            return PaperboardMessages.search
        case .search:
            return PaperboardMessages.search
        case .continue:
            return PaperboardMessages.continue
        default:
            return PaperboardMessages.return
        }
    }
    
}
