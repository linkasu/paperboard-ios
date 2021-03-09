//
//  SettingsMasterViewController.swift
//  Paperboard
//
//  Created by Igor Zapletnev on 08.03.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import Foundation
import UIKit

enum Setting {
    case columns
    case keyboard
}

class SettingItemCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
}

class SettingsMasterViewController: UITableViewController {
    
    var settings: Settings!
    let items: [Setting] = [Setting.columns, Setting.keyboard]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = PaperboardLocalizable.settingsTitle.message()
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
        
        settings.onColumnAmountChanged.append({ [weak self] newColumns in
            guard let `self` = self else {
                return
            }
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SettingItemCell {
                cell.valueLabel.text = String(self.settings.currentColumns)
            }
        })
        
        settings.onKeyboardChanged.append({ [weak self] newKeyboard in
            guard let `self` = self else {
                return
            }
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SettingItemCell {
                if let locale = self.settings.currentKeyboard?.locale {
                    cell.valueLabel.text = locale
                } else {
                    cell.valueLabel.text = PaperboardLocalizable.settingKeyboardDefault.message()
                }
            }
        })
    }
        
    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingItem", for: indexPath) as! SettingItemCell
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(hex: "#F0F0F0")
        cell.selectedBackgroundView = bgColorView
        
        switch items[indexPath.row] {
        case .columns:
            cell.nameLabel.text = PaperboardLocalizable.settingsColumns.message()
            cell.iconView.image = UIImage(named: "columns")
            cell.valueLabel.text = String(settings.currentColumns)
        case .keyboard:
            cell.nameLabel.text = PaperboardLocalizable.settingsKeyboard.message()
            cell.iconView.image = UIImage(named: "keyboard")
            if let locale = settings.currentKeyboard?.locale {
                cell.valueLabel.text = locale
            } else {
                cell.valueLabel.text = PaperboardLocalizable.settingKeyboardDefault.message()
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        switch items[indexPath.row] {
        case .columns:
            let columnsNavViewController = storyBoard.instantiateViewController(withIdentifier: "ColumnsViewNavController") as! UINavigationController
            let columnsViewController = columnsNavViewController.viewControllers.first as? ColumnsViewController
            columnsViewController?.settings = settings
            splitViewController?.showDetailViewController(columnsNavViewController, sender: nil)
        case .keyboard:
            let keyboardNavViewController = storyBoard.instantiateViewController(withIdentifier: "KeyboardNavViewController") as! UINavigationController
            let keyboardViewController = keyboardNavViewController.viewControllers.first as? KeyboardViewController
            keyboardViewController?.settings = settings
            splitViewController?.showDetailViewController(keyboardNavViewController, sender: nil)
        }
    }
}
