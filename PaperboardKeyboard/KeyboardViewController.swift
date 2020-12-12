//
//  KeyboardViewController.swift
//  PaperboardKeyboard
//
//  Created by Igor Zapletnev on 08.12.2020.
//  Copyright © 2020 Ice Rock. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    private let keyboardViewContoller = MainKeyboardViewController()
    
    private let inputSource = InputCollectionDataSource()
    private let inputLayout = InputCollectionLayout()
    private var inputCollectionProcessor: InputCollectionProcessor!
    private let speechProcessor = TextToSpeechProcessor()
    private let settings = Settings()
    
    private var caps = false
    private var heightConstraint: NSLayoutConstraint!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("I AM HERE")
        heightConstraint = self.view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.7)
        heightConstraint.isActive = true
        inputSource.numberOfColumns = settings.currentColumns
        inputSource.currentKeyboard = settings.currentKeyboard
        
        print(settings.currentKeyboard)
        
        self.addChild(keyboardViewContoller)
        self.view.addSubview(keyboardViewContoller.view)
        keyboardViewContoller.view.translatesAutoresizingMaskIntoConstraints = false
        keyboardViewContoller.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        keyboardViewContoller.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        keyboardViewContoller.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        keyboardViewContoller.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        inputSource.setup(forCollection: keyboardViewContoller.inputCollectionView)
        inputCollectionProcessor = InputCollectionProcessor(withSource: inputSource)
        inputLayout.inputSource = inputSource
        keyboardViewContoller.inputCollectionView.collectionViewLayout = inputLayout
        keyboardViewContoller.inputCollectionView.delegate = inputCollectionProcessor
        keyboardViewContoller.inputCollectionView.allowsSelection = true
        keyboardViewContoller.inputCollectionView.isPagingEnabled = true
        
        keyboardViewContoller.prevButtonTouched = {
            self.inputCollectionProcessor.scrollPrev(self.keyboardViewContoller.inputCollectionView)
            self.allowScrollInteraction(false)
        }
        
        keyboardViewContoller.nextButtonTouched = {
            self.inputCollectionProcessor.scrollNext(self.keyboardViewContoller.inputCollectionView)
            self.allowScrollInteraction(false)
        }
        
        inputCollectionProcessor.onScrollEnded = { [weak self] in
            self?.allowScrollInteraction(true)
            self?.updateButtonsTitles()
        }
        
        inputCollectionProcessor.onScrollEnded = { [weak self] in
            self?.allowScrollInteraction(true)
            self?.updateButtonsTitles()
        }
        
        keyboardViewContoller.backspaceButtonTouched = { [weak self] in
            self?.textDocumentProxy.deleteBackward()
        }
        
        keyboardViewContoller.clearButtonTouched = { [weak self] in
            if let afterInput = self?.textDocumentProxy.documentContextAfterInput {
                self?.textDocumentProxy.adjustTextPosition(byCharacterOffset: afterInput.count)
            }
            while let _ = self?.textDocumentProxy.documentContextBeforeInput {
                self?.textDocumentProxy.deleteBackward()
            }
        }
        
        keyboardViewContoller.capsLockButtonTouched = { [weak self] in
            if let capsVal = self?.caps {
                self?.caps = !capsVal
            }
        }
        
        keyboardViewContoller.speechButtonTouched = { [weak self] in
            if let documentProxy = self?.textDocumentProxy {
                let text = (documentProxy.documentContextBeforeInput ?? "") + (documentProxy.documentContextAfterInput ?? "")
                self?.speechProcessor.speechText(text)
            }
        }
        
        inputCollectionProcessor.onCellSelected = { [weak self] indexPath in
            guard let source = self?.inputSource,
                  let letter = source.letter(forIndexPath: indexPath) else {
                return
            }
            let toAppend = source.printableVariant(ofLetter:  letter)
            if let capsVal = self?.caps {
                self?.textDocumentProxy.insertText(capsVal ? toAppend.capitalized : toAppend)
            }
        }
        updateButtonsTitles()
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
    
    private func allowScrollInteraction(_ allowed: Bool) {
        keyboardViewContoller.prevButton.isUserInteractionEnabled = allowed
        keyboardViewContoller.nextButton.isUserInteractionEnabled = allowed
    }
    
    private func updateButtonsTitles() {
        let currentSection = Int(roundf(Float(keyboardViewContoller.inputCollectionView.contentOffset.x / keyboardViewContoller.inputCollectionView.frame.width)))
        let totalSections = inputSource.sections.count
        let nextSection = (currentSection + 1) % totalSections
        let prevSection = (currentSection - 1 + totalSections) % totalSections
        let titleProduce: ((Int) -> String) = { sectionNumber -> String in
            let values = self.inputSource.sections[sectionNumber].values
            if values.count < 5 {
                return values.joined(separator: ",")
            }
            return [values.prefix(2), ["..."], values.suffix(1)].flatMap({ $0 }).joined(separator: ",")
        }
        keyboardViewContoller.prevButton.setTitle("⬅️\n" + titleProduce(prevSection).uppercased(), for: .normal)
        keyboardViewContoller.nextButton.setTitle("➡️\n" + titleProduce(nextSection).uppercased(), for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        handleRotation()
        keyboardViewContoller.inputCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
    }
    
}
