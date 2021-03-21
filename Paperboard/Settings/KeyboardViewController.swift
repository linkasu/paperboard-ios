//
//  KeyboardViewController.swift
//  Paperboard
//
//  Created by Igor Zapletnev on 08.03.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import Foundation
import UIKit

class KeyboardCell: UITableViewCell {
    static let id = "KeyboardCell"
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var trailingMargin: NSLayoutConstraint!
    @IBOutlet weak var leadingMargin: NSLayoutConstraint!
    
    var isChecked: Bool = false {
        didSet {
            checkImageView.isHidden = !isChecked
        }
    }
}

class KeyboardViewController: UIViewController {
    var settings: Settings!
    @IBOutlet weak var tableView: UITableView!
    
    var keyboardTitles: [String] = []
    var selectedIndex: Int = -1
    override func viewDidLoad() {
        navigationItem.title = PaperboardMessages.settingsKeyboard.text
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        
        keyboardTitles = settings.keyboards.map({ "\($0.voiceName) - \(NSLocale.current.localizedString(forLanguageCode: $0.locale) ?? PaperboardMessages.settingsKeyboardUnknownLanguage.text) (\($0.locale))"})
        keyboardTitles.insert(PaperboardMessages.settingKeyboardDefault.text, at: 0)
        
        if let i = settings.keyboards.index(where: { $0.voiceId == settings.currentKeyboard?.voiceId }) {
            selectedIndex = i + 1
        } else {
            selectedIndex = 0
        }
        super.viewDidLoad()
    }
}

extension KeyboardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyboardTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KeyboardCell.id, for: indexPath) as! KeyboardCell
        cell.titleLabel.text = keyboardTitles[indexPath.row]
        cell.isChecked = indexPath.row == selectedIndex
        cell.selectionStyle = .none
        
        if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape {
            cell.trailingMargin.constant = 100
            cell.leadingMargin.constant = 100
        } else {
            cell.trailingMargin.constant = 20
            cell.leadingMargin.constant = 20
        }
        return cell
    }
}

extension KeyboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prevSel = IndexPath(row: selectedIndex, section: 0)
        if let prevCell = tableView.cellForRow(at: prevSel) as? KeyboardCell {
            prevCell.isChecked = false
        }
        if let cell = tableView.cellForRow(at: indexPath) as? KeyboardCell {
            cell.isChecked = true
            selectedIndex = indexPath.row
            
            settings.currentKeyboard = indexPath.row == 0 ? nil : settings.keyboards[indexPath.row - 1]
        }
    }
}
