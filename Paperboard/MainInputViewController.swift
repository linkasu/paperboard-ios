//
//  ViewController.swift
//  Paperboard
//
//  Created by Andrey Tchernov on 16.08.2018.
//  Copyright © 2018 Ice Rock. All rights reserved.
//

import UIKit

class MainInputViewController: MainKeyboardViewController {
    
    @IBOutlet private weak var inputField: UITextView!
    @IBOutlet weak var cursorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var capsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var clearButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var settingsButtonWidthConstraint: NSLayoutConstraint!
    
    @IBAction func showShare(_ sender: Any) {
        guard let shareText = inputField.text else {
            return
        }
        let textToShare = [ shareText ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
        if let popOver = activityViewController.popoverPresentationController, let shareButton = shareButton {
            popOver.sourceView = self.view
            activityViewController.popoverPresentationController?.sourceRect = shareButton.frame
        }
        present(activityViewController, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        setupStatusBar()
        
        clearButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8)
        clearButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        
        talkButton?.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8)
        talkButton?.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        
        inputField.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        inputProcessor = InputFieldProcessor(inputField: inputField)
        super.viewDidLoad()
        
        setColorScheme(.light)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustSize()
    }
    
    func setupStatusBar() {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.white
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.white
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputSource.reload()
        inputCollectionView.reloadData()
        inputCollectionProcessor.scrollsToMiddleSection(inputCollectionView)
        inputField.becomeFirstResponder()
    }
    
    @IBAction func showSettings(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsSplitViewController
        vc.settings = settings
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        adjustSize()
        
        let visibleIndex = inputCollectionView.indexPathsForVisibleItems.min()
        coordinator.animate(
            alongsideTransition: nil,
            completion: { [weak self] (context) in
                self?.inputLayout.prepare()
                guard let nIndexPath = visibleIndex else {
                    return
                }
                self?.inputCollectionView.reloadData()
                self?.inputCollectionView.scrollToItem(at: nIndexPath, at: .left, animated: false)
            })
    }
    
    func adjustSize() {
        if UIDevice.current.orientation.isLandscape {
            cursorHeightConstraint = cursorHeightConstraint.changeMultiplier(multiplier: 0.143)
            capsHeightConstraint = capsHeightConstraint.changeMultiplier(multiplier: 0.19)
            clearButtonWidthConstraint = clearButtonWidthConstraint.changeMultiplier(multiplier: 0.173)
            settingsButtonWidthConstraint = settingsButtonWidthConstraint.changeMultiplier(multiplier: 0.096)
            
            clearButton.setTitle(PaperboardLocalizable.clear.message(), for: .normal)
            talkButton?.setTitle(PaperboardLocalizable.talk.message(), for: .normal)
        } else {
            cursorHeightConstraint = cursorHeightConstraint.changeMultiplier(multiplier: 0.146)
            capsHeightConstraint = capsHeightConstraint.changeMultiplier(multiplier: 0.20)
            clearButtonWidthConstraint = clearButtonWidthConstraint.changeMultiplier(multiplier: 0.143)
            settingsButtonWidthConstraint = settingsButtonWidthConstraint.changeMultiplier(multiplier: 0.143)
            
            clearButton.setTitle("", for: .normal)
            talkButton?.setTitle("", for: .normal)
        }
    }
}
