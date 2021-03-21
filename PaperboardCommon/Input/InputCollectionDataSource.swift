//
//  InputCollectionDataSource.swift
//  Paperboard
//
//  Created by Andrey Tchernov on 16.08.2018.
//  Copyright © 2018 Ice Rock. All rights reserved.
//

import UIKit

private let inputCellXib = "InputCollectionViewCell"
private let inputCellReuse = "InputCellReuseID"

/*
 * Generate cells from alphabet
 */
class InputCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    var onCellSelected: ((IndexPath) -> Void)?
    var colorScheme = PaperboardColors(colorScheme: .light)
    var inputProcessor: InputProcessor!
    
    struct SquareSection {
        let size: Int
        let values: [String]
    }
    
    private var alphabet: [String] = {
        return PaperboardMessages.alphabet.text.split(separator: " ").map{ String($0) }
    }()
    
    private weak var collection: UICollectionView?
    
    private (set) var sections = [SquareSection]()
    private (set) var sectionSize: Int = 0
    
    var numberOfColumns: Int = 3 {
        didSet {
            reload()
        }
    }
    
    var currentKeyboard: Settings.Keyboard? {
        didSet {
            reload()
        }
    }
    
    var currentSumbols: [Settings.Symbols] = [] {
        didSet {
            reload()
        }
    }
    
    func printableVariant(ofLetter letter: String) -> String {
        return letter == "␣" ? " " : letter
    }
    
    func reload() {
        //update sections data
        let squareSize = numberOfColumns * numberOfColumns
        var tempAlphabet = ["."]
        tempAlphabet += currentKeyboard?.alphabet.split(separator: " ").map{ String($0) } ?? alphabet
        
        Settings.allSymbols.forEach { s in
            if let _ = currentSumbols.firstIndex(of: s) {
                tempAlphabet += Settings.getSymbols(symbol: s)
            }
        }
        sections.removeAll()
        while tempAlphabet.count > squareSize {
            let sectionValues = tempAlphabet.prefix(squareSize)
            sections.append(SquareSection(size: numberOfColumns, values: sectionValues.map{ $0 }))
            tempAlphabet = tempAlphabet.dropFirst(squareSize).map{ $0 }
        }
        guard !tempAlphabet.isEmpty else {
            return
        }
        guard let possibleSize = (1...numberOfColumns).first(where: { ($0 * $0) >= tempAlphabet.count }) else {
            return
        }
        sections.append(SquareSection(size: possibleSize, values: tempAlphabet))
        sectionSize = sections.count
        sections = [sections, sections, sections].flatMap({ $0 })
    }
    
    func setup(forCollection collectionView: UICollectionView) {
        collectionView.register(UINib.init(nibName: inputCellXib, bundle: nil), forCellWithReuseIdentifier: inputCellReuse)
        collectionView.dataSource = self
    }
    
    func letter(forIndexPath indexPath: IndexPath) -> String? {
        return sections[safe: indexPath.section]?.values[safe: indexPath.row]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: inputCellReuse,
            for: indexPath
        )
        guard let collectionCell = cell as? InputCollectionViewCell else {
            return cell
        }
        
        collectionCell.onButtonPressed = { [weak self] in
            self?.onCellSelected?(indexPath)
        }
        
        let toFill = letter(forIndexPath: indexPath) ?? ""
        collectionCell.fill(with: inputProcessor.isCaps() ? toFill.capitalized : toFill)
        collectionCell.characterButton.setTitleColor(colorScheme.textColor, for: [])
        collectionCell.characterButton.tintColor = colorScheme.textColor
        collectionCell.characterButton.defaultBackgroundColor = colorScheme.main.backgroundColor
        collectionCell.characterButton.highlightBackgroundColor = colorScheme.main.highlightColor
        
        return cell
    }
}
