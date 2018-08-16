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

class InputCollectionDataSource: NSObject, UICollectionViewDataSource {
  
  struct SquareSection {
    let size: Int
    let values: [String]
  }
  
  private var alphabet: [String] = {
    return " abcdefghi".map({ String($0) })
  }()
  
  private weak var collection: UICollectionView?
  
  private (set) var sections = [SquareSection]()
  
  var numberOfColumns: Int = 2 {
    didSet {
      reload()
    }
  }
  
  private func reload() {
    //update sections data
    let squareSize = numberOfColumns * numberOfColumns
    var tempAlphabet = alphabet
    sections.removeAll()
    while tempAlphabet.count > squareSize {
      let sectionValues = tempAlphabet.prefix(squareSize)
      sections.append(SquareSection(size: squareSize, values: sectionValues.map{ $0 }))
      tempAlphabet = tempAlphabet.dropFirst(squareSize).map{ $0 }
    }
    guard !tempAlphabet.isEmpty else {
      return
    }
    guard let possibleSize = (1...numberOfColumns).first(where: { $0 * $0 >= tempAlphabet.count }) else {
      return
    }
    sections.append(SquareSection(size: possibleSize, values: tempAlphabet))
    //
  }
  
  func setup(forCollection collectionView: UICollectionView) {
    collectionView.register(UINib.init(nibName: "InputCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InputCellReuseID")
    collectionView.dataSource = self
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sections[section].values.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: inputCellReuse, for: indexPath)
    (cell as? InputCollectionViewCell)?.fill(with: sections[indexPath.section].values[indexPath.row])
    return cell
  }
}
