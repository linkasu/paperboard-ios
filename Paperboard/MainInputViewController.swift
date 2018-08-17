//
//  ViewController.swift
//  Paperboard
//
//  Created by Andrey Tchernov on 16.08.2018.
//  Copyright © 2018 Ice Rock. All rights reserved.
//

import UIKit

class MainInputViewController: UIViewController {
  
  @IBOutlet private weak var inputCollection: UICollectionView!
  @IBOutlet private weak var inputField: UITextField!
  
  private let inputSource = InputCollectionDataSource()
  private let inputLayout = InputCollectionLayout()
  private let inputFieldProcessor = InputFieldProcessor()
  private var inputCollectionProcessor: InputCollectionProcessor!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //TODO: Relocate setup and linking in storyboard
    inputSource.setup(forCollection: inputCollection)
    inputField.delegate = inputFieldProcessor
    inputCollectionProcessor = InputCollectionProcessor(withSource: inputSource)
    inputLayout.inputSource = inputSource
    inputCollection.collectionViewLayout = inputLayout
    inputCollection.delegate = inputCollectionProcessor
    inputCollection.allowsSelection = true
    inputFieldProcessor.onUpdate = { [weak self] newValue in
      self?.inputField.text = newValue
    }
    
    inputCollectionProcessor.onCellSelected = { [weak self] indexPath in
      guard let letter = self?.inputSource.letter(forIndexPath: indexPath) else {
        return
      }
      self?.inputFieldProcessor.appendLetter(letter)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    inputSource.reload()
    inputCollection.reloadData()
    inputCollectionProcessor.scrollsToMiddleSection(inputCollection)
    inputField.becomeFirstResponder()
  }

}

