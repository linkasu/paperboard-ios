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
        self.navigationItem.title = PaperboardMessages.settingsColumns.text
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let isLargeMode = UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape
        let itemSize = isLargeMode ? CGSize(width: 105, height: 80) : CGSize(width: 80, height: 64)
        
        let columnLayout = FlowLayout(
            itemSize: itemSize,
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        )
        collectionView.collectionViewLayout = columnLayout
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .always
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
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
        return 5
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

class FlowLayout: UICollectionViewFlowLayout {
    
    required init(itemSize: CGSize, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        super.init()
        
        self.itemSize = itemSize
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        if #available(iOS 11.0, *) {
            sectionInsetReference = .fromSafeArea
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        guard scrollDirection == .vertical else { return layoutAttributes }
        
        // Filter attributes to compute only cell attributes
        let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })
        
        // Group cell attributes by row (cells with same vertical center) and loop on those groups
        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
            // Get the total width of the cells on the same row
            let cellsTotalWidth = attributes.reduce(CGFloat(0)) { (partialWidth, attribute) -> CGFloat in
                partialWidth + attribute.size.width
            }
            
            var totalInset: CGFloat = 0
            // Calculate the initial left inset
            if #available(iOS 11.0, *) {
                totalInset = collectionView!.safeAreaLayoutGuide.layoutFrame.width - cellsTotalWidth - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(attributes.count - 1)
            } else {
                totalInset = collectionView!.bounds.width - cellsTotalWidth - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(attributes.count - 1)
            }
            var leftInset = (totalInset / 2 * 10).rounded(.down) / 10 + sectionInset.left
            
            // Loop on cells to adjust each cell's origin and prepare leftInset for the next cell
            for attribute in attributes {
                attribute.frame.origin.x = leftInset
                leftInset = attribute.frame.maxX + minimumInteritemSpacing
            }
        }
        return layoutAttributes
    }    
}
