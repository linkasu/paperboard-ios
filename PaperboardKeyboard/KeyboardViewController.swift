//
//  KeyboardViewController.swift
//  PaperboardKeyboard
//
//  Created by Igor Zapletnev on 08.12.2020.
//  Copyright © 2020 Ice Rock. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    private let inputSource = InputCollectionDataSource()
    private let inputLayout = InputCollectionLayout()
    private let settings = Settings()
    
    var inputCollection: UICollectionView!
    var heightConstraint: NSLayoutConstraint!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        heightConstraint = self.view.heightAnchor.constraint(equalToConstant: 300)
//        heightConstraint.isActive = true
//
//        let bottomBar = createBottomBar()
        
//        inputSource.numberOfColumns = settings.currentColumns
//        inputSource.currentKeyboard = settings.currentKeyboard
//
//        inputCollection = UICollectionView(frame: .zero, collectionViewLayout: inputLayout)
//        inputCollection.translatesAutoresizingMaskIntoConstraints = false
//        inputCollection.backgroundColor = UIColor.red
//        self.view.addSubview(inputCollection)
//        inputCollection.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        inputCollection.bottomAnchor.constraint(equalTo: bottomBar.topAnchor).isActive = true
//        inputCollection.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        inputCollection.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//
//        inputSource.setup(forCollection: inputCollection)
//        inputLayout.inputSource = inputSource
//        inputCollection.collectionViewLayout = inputLayout
//        inputCollection.allowsSelection = true
//        //inputCollection.isScrollEnabled = false
//        inputCollection.isPagingEnabled = true
    }
    
    func createBottomBar() -> UIView {
        let bottom = UIView()
        bottom.backgroundColor = UIColor.blue
        self.view.addSubview(bottom)
        
        self.view.backgroundColor = UIColor.green
        
        bottom.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bottom.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bottom.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottom.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return bottom
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //inputCollection.collectionViewLayout.invalidateLayout()
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
