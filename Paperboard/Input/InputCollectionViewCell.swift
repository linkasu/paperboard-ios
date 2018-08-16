//
//  InputCollectionViewCell.swift
//  Paperboard
//
//  Created by Andrey Tchernov on 16.08.2018.
//  Copyright © 2018 Ice Rock. All rights reserved.
//

import UIKit

class InputCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet private weak var characterLabel: UILabel!
  
  func fill(with value: String) {
    characterLabel.text = value
  }
}
