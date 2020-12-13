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
    
    let inputSource = InputCollectionDataSource()
    let inputLayout = InputCollectionLayout()
    let speechProcessor = TextToSpeechProcessor()
    
    var inputCollectionProcessor: InputCollectionProcessor!
    var inputProcessor: InputProcessor!
    
    let settings = Settings()
    let defaultColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    
    @IBAction private func onSpeechButtonTouched(_ sender: UIButton!) {
        speechProcessor.speechText(inputProcessor.getText())
    }
    
    @IBAction private func onClearButtonTouched(_ sender: UIButton!) {
        inputProcessor.clear()
    }
    
    @IBAction func onCapsLocktouched(_ sender: Any) {
        inputProcessor.capsLock()
        capsLockButton.backgroundColor = inputProcessor.isCaps() ? UIColor.lightGray : defaultColor
    }
    
    @IBAction private func onPrevButtonTouched(_ sender: UIButton!) {
        inputCollectionProcessor.scrollPrev(inputCollectionView)
        allowScrollInteraction(false)
    }
    
    @IBAction private func onNextButtonTouched(_ sender: UIButton!) {
        inputCollectionProcessor.scrollNext(inputCollectionView)
        allowScrollInteraction(false)
    }
    
    @IBAction private func onBackspaceButtonTouched(_ sender: UIButton!) {
        inputProcessor.backspace()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputSource.numberOfColumns = settings.currentColumns
        inputSource.currentKeyboard = settings.currentKeyboard
        inputSource.setup(forCollection: inputCollectionView)
        inputLayout.inputSource = inputSource
        
        inputCollectionProcessor = InputCollectionProcessor(withSource: inputSource)
        inputCollectionProcessor.onScrollEnded = { [weak self] in
            self?.allowScrollInteraction(true)
            self?.updateButtonsTitles()
        }
        
        inputCollectionProcessor.onScrollEnded = { [weak self] in
            self?.allowScrollInteraction(true)
            self?.updateButtonsTitles()
        }
        
        inputCollectionView.collectionViewLayout = inputLayout
        inputCollectionView.delegate = inputCollectionProcessor
        inputCollectionView.allowsSelection = true
        
        inputCollectionProcessor.onCellSelected = { [weak self] indexPath in
            guard let source = self?.inputSource,
                  let letter = source.letter(forIndexPath: indexPath) else {
                return
            }
            let toAppend = source.printableVariant(ofLetter:  letter)
            self?.inputProcessor.append(text: toAppend)
        }
        
        settings.onColumnAmountChanged = { [weak self] newColumns in
            guard let `self` = self else {
                return
            }
            self.inputSource.numberOfColumns = newColumns
            self.updateCollection()
        }
        
        settings.onKeyboardChanged = { [weak self] newKeyboard in
            guard let `self` = self else {
                return
            }
            self.inputSource.currentKeyboard = newKeyboard
            self.updateCollection()
        }
        
        updateButtonsTitles()
    }
    
    func updateButtonsTitles() {
        let currentSection = Int(roundf(Float(inputCollectionView.contentOffset.x / inputCollectionView.frame.width)))
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
        prevButton.setTitle("⬅️\n" + titleProduce(prevSection).uppercased(), for: .normal)
        nextButton.setTitle("➡️\n" + titleProduce(nextSection).uppercased(), for: .normal)
    }
    
    private func updateCollection() {
        inputLayout.prepare()
        inputCollectionView
            .reloadData()
        inputCollectionView.setCollectionViewLayout(inputLayout, animated: false)
        inputCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        updateButtonsTitles()
    }
    
    private func allowScrollInteraction(_ allowed: Bool) {
        prevButton.isUserInteractionEnabled = allowed
        nextButton.isUserInteractionEnabled = allowed
    }
}
