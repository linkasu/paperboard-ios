//
//  SetColumnsViewController.swift
//  Paperboard
//
//  Created by Andrey Tchernov on 18.08.2018.
//  Copyright © 2018 Ice Rock. All rights reserved.
//

import UIKit

class SetColumnsViewController: UIViewController {
  
  private let settings = SettingsManager()
  
  @IBOutlet weak var columnsSLider: UISlider!
  @IBOutlet weak var thumbLabel: UILabel!
  
  private var onAmountChanges: ((Int) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let value = (settings.getSettingValue(.columns) as? NSNumber)?.floatValue ?? columnsSLider.minimumValue
    thumbLabel.text = "\(Int(roundf(value)))"

    columnsSLider.setValue(value, animated: true)
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    view.layoutSubviews()
    updateThumbLabel(onSlider: columnsSLider, toValue: columnsSLider.value)
  }
  
  @IBAction func okPressed(_ sender: UIButton!) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func sliderChanged(_ sender: UISlider!, forEvent event: UIEvent) {
    guard !(event.allTouches?.isEmpty ?? true) else {
      return
    }
    let finalValue: Float
    if sender.value < 2.5 {
      finalValue = 2
    }
    else if sender.value > 4.5 {
      finalValue = 5
    } else {
      finalValue = roundf(sender.value)
    }
    let intValue = Int(finalValue)
    onAmountChanges?(intValue)
    thumbLabel.text = "\(intValue)"
    settings.update(.columns, withValue: NSNumber(value: finalValue))
    UIView.animate(withDuration: 0.25) {
      sender.setValue(finalValue, animated: true)
      self.updateThumbLabel(onSlider: sender, toValue: finalValue)
    }
  }
  
  private func updateThumbLabel(onSlider slider: UISlider, toValue: Float) {
    let thumbFrame = slider.thumbRect(forBounds: slider.bounds, trackRect: slider.trackRect(forBounds: slider.bounds), value: toValue)
    thumbLabel.frame = thumbFrame.offsetBy(dx: slider.frame.minX, dy: slider.frame.minY)
  }
  
  class func push(from controller: UIViewController, withChangesCallback callback: ((Int) -> Void)? = nil) -> SetColumnsViewController {
    let setColumnsVC = SetColumnsViewController(nibName: "SetColumnsViewController", bundle: nil)
    setColumnsVC.modalPresentationStyle = .overFullScreen
    setColumnsVC.onAmountChanges = callback
    controller.present(setColumnsVC, animated: true, completion: nil)
    return setColumnsVC
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: nil, completion: {
      context in
      self.updateThumbLabel(onSlider: self.columnsSLider, toValue: self.columnsSLider.value)
    })
  }
}
