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
  
  @IBOutlet private weak var prevButton: UIButton!
  @IBOutlet private weak var nextButton: UIButton!
  
  private let inputSource = InputCollectionDataSource()
  private let inputLayout = InputCollectionLayout()
  private let inputFieldProcessor = InputFieldProcessor()
  private let speechProcessor = TextToSpeechProcessor()
  private var inputCollectionProcessor: InputCollectionProcessor!
  private let settings = SettingsProcessor()
  
  @IBAction private func showSettings(_ sender: UIBarButtonItem!) {
    settings.showSettings(onController: self, byBarButton: sender)
  }
  
  @IBAction private func onSpeechButtonTouched(_ sender: UIButton!) {
    guard !inputFieldProcessor.currentValue.isEmpty else {
      return
    }
    speechProcessor.speechText(inputFieldProcessor.currentValue)
  }
  
  @IBAction private func onClearButtonTouched(_ sender: UIButton!) {
    inputFieldProcessor.clear()
  }
  
  @IBAction private func onPrevButtonTouched(_ sender: UIButton!) {
    inputCollectionProcessor.scrollPrev(inputCollection)
    allowScrollInteraction(false)
  }
  
  @IBAction private func onNextButtonTouched(_ sender: UIButton!) {
    inputCollectionProcessor.scrollNext(inputCollection)
    allowScrollInteraction(false)
  }
  
  @IBAction private func onBackspaceButtonTouched(_ sender: UIButton!) {
    inputFieldProcessor.backSpace()
  }
  
  private func allowScrollInteraction(_ allowed: Bool) {
    self.prevButton.isUserInteractionEnabled = allowed
    self.nextButton.isUserInteractionEnabled = allowed
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //TODO: Relocate setup and linking in storyboard
    inputSource.numberOfColumns = (SettingsManager().getSettingValue(.columns) as? NSNumber)?.intValue ?? 3
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
    
    inputCollectionProcessor.onScrollEnded = { [weak self] in
      self?.allowScrollInteraction(true)
    }
    
    settings.onColumnAmountChanged = { [weak self] newColumns in
      guard let `self` = self else {
        return
      }
      self.inputSource.numberOfColumns = newColumns
      self.inputLayout.prepare()
      self.inputCollection.reloadData()
      self.inputCollection.setCollectionViewLayout(self.inputLayout, animated: false)
      self.inputCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    inputSource.reload()
    inputCollection.reloadData()
    inputCollectionProcessor.scrollsToMiddleSection(inputCollection)
    inputField.becomeFirstResponder()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    let visibleIndex = inputCollection.indexPathsForVisibleItems.min()
    coordinator.animate(
      alongsideTransition: nil,
      completion: { [weak self] (context) in
        self?.inputLayout.prepare()
        if let nIndexPath = visibleIndex {
          self?.inputCollection.reloadData()
          self?.inputCollection.scrollToItem(at: nIndexPath, at: .left, animated: false)
        }
    })
  }
}

