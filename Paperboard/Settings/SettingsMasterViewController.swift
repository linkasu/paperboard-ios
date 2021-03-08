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

class SettingsMasterViewController: UITableViewController {
    
    let items: [Setting] = [Setting.columns, Setting.keyboard]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = PaperboardLocalizable.settingsTitle.message()
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
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
            cell.valueLabel.text = "3"
        case .keyboard:
            cell.nameLabel.text = PaperboardLocalizable.settingsKeyboard.message()
            cell.iconView.image = UIImage(named: "keyboard")
            cell.valueLabel.text = "En"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        switch items[indexPath.row] {
        case .columns:
            let columnsViewController = storyBoard.instantiateViewController(withIdentifier: "ColumnsViewNavController")
            splitViewController?.showDetailViewController(columnsViewController, sender: nil)
        case .keyboard:
            let keyboardViewController = storyBoard.instantiateViewController(withIdentifier: "KeyboardNavViewController")
            splitViewController?.showDetailViewController(keyboardViewController, sender: nil)
        }
    }
}
