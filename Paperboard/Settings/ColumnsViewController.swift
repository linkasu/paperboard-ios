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
    
    var settings: Settings!
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
        let prevSel = IndexPath(row: settings.currentColumns - 1, section: 0)
        if let prevCell = collectionView.cellForItem(at: prevSel) as? ColumnItemCell {
            prevCell.isSelected = false
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? ColumnItemCell {
            cell.isSelected = true
            settings.currentColumns = indexPath.row + 1
        }
    }
}

extension ColumnsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColumnItemCell.id, for: indexPath) as! ColumnItemCell
        let column = indexPath.row + 1
        cell.number.text = String(column)
        cell.contentView.layer.cornerRadius = 6.0
        cell.contentView.layer.borderWidth = 1.0
        cell.isSelected = settings?.currentColumns == column
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if UIDevice.current.orientation.isLandscape {
            return UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 100)
        }
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
}
