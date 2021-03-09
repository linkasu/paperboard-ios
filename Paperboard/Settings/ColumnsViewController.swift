//
//  ColumnsViewController.swift
//  Paperboard
//
//  Created by Igor Zapletnev on 08.03.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//
import UIKit

class ColumnItemCell: UICollectionViewCell {
    static let id = "ColumnCell"
    
    @IBOutlet weak var number: UILabel!
    
    let defColor = UIColor(hex: "#AEB3BE")
    let selColor = UIColor(hex: "#0F77F0")
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? selColor.cgColor : defColor.cgColor
            contentView.layer.opacity = isSelected ? 1.0 : 0.5
            number.textColor = isSelected ? selColor : UIColor.black
        }
    }
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColumnItemCell.id, for: indexPath) as! ColumnItemCell
        cell.isSelected = true
    }
}

extension ColumnsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColumnItemCell.id, for: indexPath) as! ColumnItemCell
        cell.number.text = String(indexPath.row + 1)
        cell.contentView.layer.cornerRadius = 6.0
        cell.contentView.layer.borderWidth = 1.0
        cell.isSelected = false
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
