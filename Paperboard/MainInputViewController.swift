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
  
  private let inputSource = InputCollectionDataSource()
  private let inputLayout = InputCollectionLayout()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    inputField.isUserInteractionEnabled = false //disable system keyboard
    inputSource.setup(forCollection: inputCollection)
    inputLayout.inputSource = inputSource
    inputCollection.collectionViewLayout = inputLayout
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    inputSource.reload()
    inputCollection.reloadData()
  }
}

