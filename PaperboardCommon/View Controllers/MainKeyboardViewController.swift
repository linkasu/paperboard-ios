//
//  MainKeyboardViewController.swift
//  Paperboard
//
//  Created by Dmitry Shipinev on 11.12.2020.
//  Copyright © 2020 Ice Rock. All rights reserved.
//

import UIKit

class MainKeyboardViewController: UIViewController {
    
    @IBOutlet weak var inputCollectionView: UICollectionView!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var backspaceButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var capsLockButton: UIButton!
    @IBOutlet weak var talkButton: UIButton!
    
    @IBOutlet var buttonsStackViews: [UIStackView]!
    
    var speechButtonTouched: (() -> ())?
    var clearButtonTouched: (() -> ())?
    var capsLockButtonTouched: (() -> ())?
    var prevButtonTouched: (() -> ())?
    var nextButtonTouched: (() -> ())?
    var backspaceButtonTouched: (() -> ())?
    
    @IBAction private func onSpeechButtonTouched(_ sender: UIButton!) {
        speechButtonTouched?()
    }
    
    @IBAction private func onClearButtonTouched(_ sender: UIButton!) {
        clearButtonTouched?()
    }
    
    @IBAction func onCapsLocktouched(_ sender: Any) {
        capsLockButtonTouched?()
    }
      
    @IBAction private func onPrevButtonTouched(_ sender: UIButton!) {
        prevButtonTouched?()
    }
    
    @IBAction private func onNextButtonTouched(_ sender: UIButton!) {
        nextButtonTouched?()
    }
    
    @IBAction private func onBackspaceButtonTouched(_ sender: UIButton!) {
        backspaceButtonTouched?()
    }
    
}
