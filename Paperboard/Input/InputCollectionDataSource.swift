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
  
  struct SquareSection {
    let size: Int
    let values: [String]
  }
  
  private var alphabet: [String] = {
    var letters = NSLocalizedString("input.alphabet", comment: "").map{ String($0) }
    letters.insert(" ", at: 0)
    return letters
  }()
  
  private weak var collection: UICollectionView?
  
  private (set) var sections = [SquareSection]()
  private (set) var sectionSize: Int = 0

  var numberOfColumns: Int = 3 {
    didSet {
      reload()
    }
  }
  
  func reload() {
    //update sections data
    let squareSize = numberOfColumns * numberOfColumns
    var tempAlphabet = alphabet
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
    collectionView.register(UINib.init(nibName: "InputCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InputCellReuseID")
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
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: inputCellReuse, for: indexPath)
    (cell as? InputCollectionViewCell)?.fill(with: letter(forIndexPath: indexPath) ?? "")
    return cell
  }
}
