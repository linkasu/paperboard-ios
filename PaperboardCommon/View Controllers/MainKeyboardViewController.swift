//
//  MainKeyboardViewController.swift
//  Paperboard
//
//  Created by Dmitry Shipinev on 11.12.2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import UIKit

class MainKeyboardViewController: UIViewController {
    @IBOutlet weak var inputCollectionView: UICollectionView!
    @IBOutlet weak var prevButton: KeyboardButton!
    @IBOutlet weak var nextButton: KeyboardButton!
    @IBOutlet weak var cursorRight: KeyboardButton!
    @IBOutlet weak var cursorLeft: KeyboardButton!
    @IBOutlet weak var backspaceButton: KeyboardButton!
    @IBOutlet weak var clearButton: KeyboardButton!
    @IBOutlet weak var capsLockButton: KeyboardButton!
    @IBOutlet weak var talkButton: KeyboardButton?
    @IBOutlet weak var settingsButton: KeyboardButton?
    @IBOutlet weak var shareButton: KeyboardButton?
    @IBOutlet weak var spaceButton: KeyboardButton!
    @IBOutlet weak var actionButton: KeyboardButton?
    @IBOutlet weak var changeKeyboard: KeyboardButton!
    @IBOutlet weak var doneButton: KeyboardButton!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var capsHeightConstraint: NSLayoutConstraint!
    
    let inputSource = InputCollectionDataSource()
    let inputLayout = InputCollectionLayout()
    let speechProcessor = TextToSpeechProcessor()
    
    var inputCollectionProcessor: InputCollectionProcessor!
    var inputProcessor: InputProcessor! {
        didSet {
            inputSource.inputProcessor = inputProcessor
        }
    }
    
    let settings = Settings()
    var isClearSystem: Bool = true
    let spacingTablet = 12
    let spacingPhone = 6
    
    @IBAction func onActionTouched(_ sender: Any) {
        inputProcessor.return()
    }
    
    @IBAction func onSpaceTouched(_ sender: Any) {
        inputProcessor.space()
    }
    
    @IBAction func onKeyboardTouched(_ sender: Any) {
        inputProcessor.changeKeyboard()
    }
    
    @IBAction private func onSpeechButtonTouched(_ sender: UIButton!) {
        UIDevice.current.playInputClick()
        speechProcessor.speechText(inputProcessor.getText())
    }
    
    @IBAction private func onClearButtonTouched(_ sender: UIButton!) {
        UIDevice.current.playInputClick()
        inputProcessor.clear()
    }
    
    @IBAction func onCapsLocktouched(_ sender: Any) {
        UIDevice.current.playInputClick()
        inputProcessor.capsLock()
        let newImage = UIImage(named: inputProcessor.isCaps() ? "shift-on" : "shift-off")
        capsLockButton.setImage(newImage, for: .normal)
        inputCollectionView.reloadData()
    }
    
    @IBAction private func onPrevButtonTouched(_ sender: UIButton!) {
        UIDevice.current.playInputClick()
        inputCollectionProcessor.scrollPrev(inputCollectionView)
        allowScrollInteraction(false)
    }
    
    @IBAction private func onNextButtonTouched(_ sender: UIButton!) {
        UIDevice.current.playInputClick()
        inputCollectionProcessor.scrollNext(inputCollectionView)
        allowScrollInteraction(false)
    }
    
    @IBAction private func onBackspaceButtonTouched(_ sender: UIButton!) {
        UIDevice.current.playInputClick()
        inputProcessor.backspace()
    }
    
    @IBAction func onDoneButtonTouched(_ sender: Any) {
        UIDevice.current.playInputClick()
        inputProcessor.done()
    }
    
    @IBAction func onRightButtonTouched(_ sender: Any) {
        UIDevice.current.playInputClick()
        inputProcessor.right()
    }
    
    @IBAction func onLeftButtonTouched(_ sender: Any) {
        UIDevice.current.playInputClick()
        inputProcessor.left()
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
        
        inputSource.onCellSelected = { [weak self] indexPath in
            UIDevice.current.playInputClick()
            guard let source = self?.inputSource,
                  let letter = source.letter(forIndexPath: indexPath) else {
                return
            }
            let toAppend = source.printableVariant(ofLetter:  letter)
            self?.inputProcessor.append(text: toAppend)
        }
        
        settings.onColumnAmountChanged.append({ [weak self] newColumns in
            guard let `self` = self else {
                return
            }
            self.inputSource.numberOfColumns = newColumns
            self.updateCollection()
        })
        
        settings.onKeyboardChanged.append({ [weak self] newKeyboard in
            guard let `self` = self else {
                return
            }
            self.inputSource.currentKeyboard = newKeyboard
            self.updateCollection()
        })
        
        prevButton.titleLabel?.textAlignment = .center
        nextButton.titleLabel?.textAlignment = .center
        prevButton.titleLabel?.numberOfLines = 2
        nextButton.titleLabel?.numberOfLines = 2
        
        updateButtonsTitles()
        
        let isCompact = UIDevice.current.userInterfaceIdiom == .phone
        
        let spacing = isCompact ? spacingPhone : spacingTablet
        inputLayout.spacing = NSNumber(value: spacing)
        configureSpacing(spacing: spacing)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let bounds = inputCollectionView?.bounds {
            let newHeight = (bounds.height - (2 * CGFloat(truncating: inputLayout.spacing))) / 3
            capsHeightConstraint.constant = newHeight
        }
    }
    
    func configureSpacing(spacing: Int) {
        [cursorLeft, cursorRight, prevButton, nextButton, capsLockButton,
         backspaceButton, inputCollectionView, bottomBarView, inputCollectionView,
         settingsButton, spaceButton, shareButton, talkButton, actionButton,
         clearButton, doneButton, nextButton
        ].forEach { view in
            view?.configureSpacing(spacing: spacing)
        }
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
        prevButton.setTitle(titleProduce(prevSection).uppercased(), for: .normal)
        prevButton.centerVertically()
        nextButton.setTitle(titleProduce(nextSection).uppercased(), for: .normal)
        nextButton.centerVertically()
    }
    
    private func updateCollection() {
        inputLayout.prepare()
        inputCollectionView.reloadData()
        inputCollectionView.setCollectionViewLayout(inputLayout, animated: false)
        inputCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        updateButtonsTitles()
    }
    
    private func allowScrollInteraction(_ allowed: Bool) {
        prevButton.isUserInteractionEnabled = allowed
        nextButton.isUserInteractionEnabled = allowed
    }
    
    func setColorScheme(_ colorScheme: PaperboardColorScheme) {
        let colorScheme = PaperboardColors(colorScheme: colorScheme)
        
        inputSource.colorScheme = colorScheme
        view.backgroundColor = colorScheme.backgroundColor
        inputCollectionView.backgroundColor = colorScheme.backgroundColor
        
        for cell in inputCollectionView.visibleCells {
            if let inputCell = cell as? InputCollectionViewCell {
                inputCell.characterButton.configure(
                    colorScheme: colorScheme,
                    buttonColors: colorScheme.main
                )
            }
        }
        
        setColors(colorScheme: colorScheme)
    }
    
    func setColors(colorScheme: PaperboardColors) {
        spaceButton.configure(colorScheme: colorScheme, buttonColors: colorScheme.main)
        
        if isClearSystem {
            clearButton.configure(colorScheme: colorScheme, buttonColors: colorScheme.system)
        } else {
            clearButton.configure(colorScheme: colorScheme, buttonColors: colorScheme.control)
        }
        
        [settingsButton, shareButton].forEach {
            $0?.configure(colorScheme: colorScheme, buttonColors: colorScheme.system)
        }
        
        [changeKeyboard, doneButton, cursorLeft, cursorRight, prevButton,
         nextButton, backspaceButton, capsLockButton].forEach {
            $0?.configure(colorScheme: colorScheme, buttonColors: colorScheme.control)
         }
        [talkButton, actionButton].forEach {
            configureFocus(button: $0, colorScheme: colorScheme)
        }
    }
    
    func configureFocus(button: KeyboardButton?, colorScheme: PaperboardColors) {
        button?.configure(
            colorScheme: colorScheme,
            buttonColors: colorScheme.focus
        )
        
        button?.setTitleColor(UIColor.white, for: [])
        button?.tintColor = UIColor.white
    }
}
