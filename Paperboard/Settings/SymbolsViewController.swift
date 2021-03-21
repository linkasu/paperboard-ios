//
//  SymbolsViewController.swift
//  Paperboard
//
//  Created by Igor Zapletnev on 20.03.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//
import Foundation
import UIKit

class SymbolCell: UITableViewCell {
    static let id = "SymbolCell"
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var trailingMargin: NSLayoutConstraint!
    @IBOutlet weak var leadingMargin: NSLayoutConstraint!
    
    var isChecked: Bool = false {
        didSet {
            checkImageView.isHidden = !isChecked
        }
    }
}

class SymbolsViewController: UIViewController {
    var settings: Settings!
    @IBOutlet weak var tableView: UITableView!
    let allIndex = 0
    override func viewDidLoad() {
        navigationItem.title = PaperboardMessages.settingsSymbols.text
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        
        super.viewDidLoad()
    }
}

extension SymbolsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.allSymbols.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SymbolCell.id, for: indexPath) as! SymbolCell
        if indexPath.row == allIndex {
            cell.titleLabel.text = PaperboardMessages.symbolsAll.text
            cell.subTitleLabel.isHidden = true
            cell.isChecked = isAllChecked()
            cell.selectionStyle = .none
        } else {
            let s = Settings.allSymbols[indexPath.row - 1]
            cell.titleLabel.text = title(symbol: s)
            cell.subTitleLabel.text = Settings.getSymbols(symbol: s).joined()
            cell.isChecked = settings.currentSymbols.index(of: s) != nil
            cell.selectionStyle = .none
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape {
            cell.trailingMargin.constant = 100
            cell.leadingMargin.constant = 100
        } else {
            cell.trailingMargin.constant = 20
            cell.leadingMargin.constant = 20
        }
        return cell
    }
    
    func title(symbol: Settings.Symbols) -> String {
        switch symbol {
        case .numbers:
            return PaperboardMessages.symbolsNumbers.text
        case .punctuation:
            return PaperboardMessages.symbolsPunctuation.text
        case .math:
            return PaperboardMessages.symbolsMath.text
        case .extra:
            return PaperboardMessages.symbolsExtra.text
        case .currency:
            return PaperboardMessages.symbolsCurrency.text
        }
    }
}

extension SymbolsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SymbolCell else {
            return
        }
        
        if indexPath.row == allIndex {
            checkAll(state: !cell.isChecked)
        } else {
            let symbol = Settings.allSymbols[indexPath.row - 1]
            if let index = settings.currentSymbols.index(of: symbol) {
                settings.currentSymbols.remove(at: index)
                cell.isChecked = false
            } else {
                settings.currentSymbols.append(symbol)
                cell.isChecked = true
            }
        }
        
        if let allCell = tableView.cellForRow(at: IndexPath(row: allIndex, section: 0)) as? SymbolCell {
            allCell.isChecked = isAllChecked()
        }
        
    }
    
    
    func isAllChecked() -> Bool {
        return Settings.allSymbols.allSatisfy {
            return settings.currentSymbols.firstIndex(of: $0) != nil
        }
    }
    
    func checkAll(state: Bool) {
        for (index, symbol) in Settings.allSymbols.enumerated() {
            guard let cell = tableView.cellForRow(at: IndexPath(row: index + 1, section: 0)) as? SymbolCell else {
                continue
            }
            cell.isChecked = state
            
            if state && settings.currentSymbols.index(of: symbol) == nil {
                settings.currentSymbols.append(symbol)
            } else if !state {
                if let index = settings.currentSymbols.index(of: symbol) {
                    settings.currentSymbols.remove(at: index)
                }
            }
        }
    }
}

