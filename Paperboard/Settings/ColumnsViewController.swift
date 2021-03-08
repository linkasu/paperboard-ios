//
//  ColumnsViewController.swift
//  Paperboard
//
//  Created by Igor Zapletnev on 08.03.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//
import UIKit

class ColumnItemCell: UICollectionViewCell {
    @IBOutlet weak var number: UILabel!
}

class ColumnsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        self.navigationItem.title = PaperboardLocalizable.settingsColumns.message()
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension ColumnsViewController: UICollectionViewDelegate {
}

extension ColumnsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColumnCell", for: indexPath) as! ColumnItemCell
        cell.number.text = String(indexPath.row + 1)
        cell.contentView.layer.cornerRadius = 6.0
        cell.contentView.layer.borderColor = UIColor(hex: "#AEB3BE").cgColor
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.opacity = 0.5
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension ColumnsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
