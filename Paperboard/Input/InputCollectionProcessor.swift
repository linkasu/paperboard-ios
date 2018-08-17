//
//  InputCollectionProcessor.swift
//  Paperboard
//
//  Created by Andrey Tchernov on 17.08.2018.
//  Copyright © 2018 Ice Rock. All rights reserved.
//

import UIKit

class SelectableCollectionDelegate: NSObject, UICollectionViewDelegate {
  var onCellSelected: ((IndexPath) -> Void)?
  
  func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    onCellSelected?(indexPath)
  }
}
