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
    
    @IBOutlet weak var backspaceButton: KeyboardButton!
    @IBOutlet weak var clearButton: KeyboardButton!
    @IBOutlet weak var capsLockButton: KeyboardButton!
    @IBOutlet weak var talkButton: KeyboardButton?
    @IBOutlet weak var cursorRight: KeyboardButton!
    @IBOutlet weak var cursorLeft: KeyboardButton!
    @IBOutlet weak var settingsButton: KeyboardButton?
    @IBOutlet weak var shareButton: KeyboardButton?
    @IBOutlet weak var spaceButton: KeyboardButton!
    @IBOutlet weak var actionButton: KeyboardButton?
    @IBOutlet weak var changeKeyboard: KeyboardButton!
    @IBOutlet weak var doneButton: KeyboardButton!
    @IBOutlet weak var bottomBarView: UIView!
    
    var isClearSystem: Bool = true
    
    @IBOutlet var buttonsStackViews: [UIStackView]!
    
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
    let defaultColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    
    let spacingTablet = 12
    let spacingPhone = 6
    
    @IBOutlet weak var capsHeightConstraint: NSLayoutConstraint!
    
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
        capsLockButton.setImage(UIImage(named: inputProcessor.isCaps() ? "shift-on" : "shift-off"), for: .normal)
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
        
        let spacing = UIDevice.current.userInterfaceIdiom == .phone ? spacingPhone : spacingTablet
        inputLayout.spacing = NSNumber(value: spacing)
        configureSpacing(spacing: spacing)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let bounds = inputCollectionView?.bounds {
            capsHeightConstraint.constant = (bounds.height - (2 * CGFloat(truncating: inputLayout.spacing))) / 3
        }
    }
    
    func configureSpacing(spacing: Int) {
        [cursorLeft, cursorRight, prevButton, nextButton, capsLockButton,
         backspaceButton, inputCollectionView, bottomBarView, inputCollectionView,
         settingsButton, spaceButton, shareButton, talkButton, actionButton,
         clearButton, doneButton, nextButton
        ].forEach { configureSpacing(view: $0, spacing: spacing) }
    }
    
    func configureSpacing(view: UIView?, spacing: Int) {
        guard let view = view else {
            return
        }
        view.superview?.constraints.forEach { constaint in
            configureSpacing(constaint: constaint, anchor: view.bottomAnchor, spacing: spacing)
            configureSpacing(constaint: constaint, anchor: view.topAnchor, spacing: spacing)
            configureSpacing(constaint: constaint, anchor: view.leadingAnchor, spacing: spacing)
            configureSpacing(constaint: constaint, anchor: view.trailingAnchor, spacing: spacing)
        }
    }
    
    func configureSpacing<T>(constaint: NSLayoutConstraint, anchor: NSLayoutAnchor<T>, spacing: Int) {
        if constaint.secondAnchor == anchor || constaint.firstAnchor == anchor {
            if constaint.constant != 0 {
                constaint.constant = CGFloat(spacing)
            }
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
        centerVertically(button: prevButton)
        nextButton.setTitle(titleProduce(nextSection).uppercased(), for: .normal)
        centerVertically(button: nextButton)
    }
    
    func centerVertically(button: UIButton, spacing: CGFloat = 18.0) {
        guard let imageSize = button.imageView?.image?.size,
              let text = button.titleLabel?.text,
              let font = button.titleLabel?.font
        else { return }
        
        button.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageSize.width,
            bottom: -(imageSize.height + spacing),
            right: 0.0
        )
        
        let titleSize = text.size(withAttributes: [.font: font])
        button.imageEdgeInsets = UIEdgeInsets(
            top: -(titleSize.height + spacing),
            left: 0.0,
            bottom: 0.0,
            right: -titleSize.width
        )
        
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
        button.contentEdgeInsets = UIEdgeInsets(
            top: edgeOffset,
            left: 0.0,
            bottom: edgeOffset,
            right: 0.0
        )
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
                configureMain(button: inputCell.characterButton, colorScheme: colorScheme)
            }
        }
        
        configureMain(button: spaceButton, colorScheme: colorScheme)
        
        if isClearSystem {
            configureSystem(button: clearButton, colorScheme: colorScheme)
        } else {
            configureControl(button: clearButton, colorScheme: colorScheme)
        }
        
        if let settingsButton = settingsButton {
            configureSystem(button: settingsButton, colorScheme: colorScheme)
        }
        if let shareButton = shareButton {
            configureSystem(button: shareButton, colorScheme: colorScheme)
        }
        if let changeKeyboard = changeKeyboard {
            configureControl(button: changeKeyboard, colorScheme: colorScheme)
        }
        if let doneButton = doneButton {
            configureControl(button: doneButton, colorScheme: colorScheme)
        }
        
        configureControl(button: cursorLeft, colorScheme: colorScheme)
        configureControl(button: cursorRight, colorScheme: colorScheme)
        configureControl(button: prevButton, colorScheme: colorScheme)
        configureControl(button: nextButton, colorScheme: colorScheme)
        configureControl(button: backspaceButton, colorScheme: colorScheme)
        configureControl(button: capsLockButton, colorScheme: colorScheme)
        
        if let talkButton = talkButton {
            configureFocus(button: talkButton, colorScheme: colorScheme)
        }
        if let actionButton = actionButton {
            configureFocus(button: actionButton, colorScheme: colorScheme)
        }
    }
    
    func configureMain(button: KeyboardButton, colorScheme: PaperboardColors) {
        configure(
            button: button,
            colorScheme: colorScheme,
            background: colorScheme.mainButtonBackgroundColor,
            highlight: colorScheme.mainButtonHighlightColor
        )
    }
    
    func configureSystem(button: KeyboardButton, colorScheme: PaperboardColors) {
        configure(
            button: button,
            colorScheme: colorScheme,
            background: colorScheme.systemButtonBackgroundColor,
            highlight: colorScheme.systemButtonHighlightColor
        )
    }
    
    func configureControl(button: KeyboardButton, colorScheme: PaperboardColors) {
        configure(
            button: button,
            colorScheme: colorScheme,
            background: colorScheme.controlButtonBackgroundColor,
            highlight: colorScheme.controlButtonHighlightColor
        )
    }
    
    func configureFocus(button: KeyboardButton, colorScheme: PaperboardColors) {
        configure(
            button: button,
            colorScheme: colorScheme,
            background: colorScheme.focusButtonBackgroundColor,
            highlight: colorScheme.focusButtonHighlightColor
        )
        
        button.setTitleColor(UIColor.white, for: [])
        button.tintColor = UIColor.white
    }
    
    func configure(button: KeyboardButton, colorScheme: PaperboardColors, background: UIColor, highlight: UIColor) {
        button.setTitleColor(colorScheme.buttonTextColor, for: [])
        button.tintColor = colorScheme.buttonTextColor
        
        button.defaultBackgroundColor = background
        button.highlightBackgroundColor = highlight
    }
    
}
