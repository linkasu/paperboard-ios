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
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    onCellSelected?(indexPath)
  }
}

class InputCollectionProcessor: SelectableCollectionDelegate {
  private let inputSource: InputCollectionDataSource
  
  init(withSource source: InputCollectionDataSource) {
    inputSource = source
    super.init()
  }
  
  func scrollsToMiddleSection(_ scrollView: UIScrollView) {
    let sectionSize = CGFloat(inputSource.sectionSize) * scrollView.frame.width
    let offset = scrollView.contentOffset.x
    if offset < sectionSize {
      scrollView.setContentOffset(CGPoint(x: offset+sectionSize, y: 0), animated: false)
    }
    if offset >= 2 * sectionSize {
      scrollView.setContentOffset(CGPoint(x: offset-sectionSize, y: 0), animated: false)
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    scrollsToMiddleSection(scrollView)
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    scrollsToMiddleSection(scrollView)
  }
}
