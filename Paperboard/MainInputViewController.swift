//
//  ViewController.swift
//  Paperboard
//
//  Created by Andrey Tchernov on 16.08.2018.
//  Copyright © 2018 Ice Rock. All rights reserved.
//

import UIKit
import YandexMobileMetrica
import CoreMotion

class MainInputViewController: UIViewController {
  
  @IBOutlet private weak var inputCollection: UICollectionView!
  @IBOutlet private weak var inputField: UITextField!
  
  @IBOutlet private weak var prevButton: UIButton!
  @IBOutlet private weak var nextButton: UIButton!
  
  private let inputSource = InputCollectionDataSource()
  private let inputLayout = InputCollectionLayout()
  private let inputFieldProcessor = InputFieldProcessor()
  private let speechProcessor = TextToSpeechProcessor()
  private var inputCollectionProcessor: InputCollectionProcessor!
  private let settings = SettingsProcessor()
  
  private var motionManager: CMMotionManager!
  private var motionManagerHandleQueue: OperationQueue!
  private var motionManagerUpdatesBuffer: [Double] = []
  private var motionManagerFlushBufferTimer: Timer!
    
    private var throttler: Throttler? = nil
    public var throttlingInterval: Int = 0 {
        didSet {
            throttler = Throttler(seconds: throttlingInterval)
        }
    }
    
    
  @IBAction private func showSettings(_ sender: UIBarButtonItem!) {
    settings.showSettings(onController: self, byBarButton: sender)
  }
  
  @IBAction private func onSpeechButtonTouched(_ sender: UIButton!) {
    guard !inputFieldProcessor.currentValue.isEmpty else {
      return
    }
    speechProcessor.speechText(inputFieldProcessor.currentValue)
    YMMYandexMetrica.reportEvent("say")
  }
  
  @IBAction private func onClearButtonTouched(_ sender: UIButton!) {
    inputFieldProcessor.clear()
  }
  
  @IBAction private func onPrevButtonTouched(_ sender: UIButton!) {
    inputCollectionProcessor.scrollPrev(inputCollection)
    allowScrollInteraction(false)
  }
  
  @IBAction private func onNextButtonTouched(_ sender: UIButton!) {
    inputCollectionProcessor.scrollNext(inputCollection)
    allowScrollInteraction(false)
  }
  
  @IBAction private func onBackspaceButtonTouched(_ sender: UIButton!) {
    inputFieldProcessor.backSpace()
  }
  
  private func allowScrollInteraction(_ allowed: Bool) {
    self.prevButton.isUserInteractionEnabled = allowed
    self.nextButton.isUserInteractionEnabled = allowed
  }
    
    deinit {
        motionManagerFlushBufferTimer.invalidate()
        motionManagerFlushBufferTimer = nil
    }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //TODO: Relocate setup and linking in storyboard
    inputSource.numberOfColumns = settings.currentColumns
    inputSource.currentKeyboard = settings.currentKeyboard
    
    inputSource.setup(forCollection: inputCollection)
    inputField.delegate = inputFieldProcessor
    inputCollectionProcessor = InputCollectionProcessor(withSource: inputSource)
    inputLayout.inputSource = inputSource
    inputCollection.collectionViewLayout = inputLayout
    inputCollection.delegate = inputCollectionProcessor
    inputCollection.allowsSelection = true
    inputFieldProcessor.onUpdate = { [weak self] newValue in
      self?.inputField.text = newValue
    }
    
    inputCollectionProcessor.onCellSelected = { [weak self] indexPath in
      guard let source = self?.inputSource,
        let letter = source.letter(forIndexPath: indexPath) else {
        return
      }
      self?.inputFieldProcessor.appendLetter(source.printableVariant(ofLetter: letter))
    }
    
    inputCollectionProcessor.onScrollEnded = { [weak self] in
      self?.allowScrollInteraction(true)
      self?.updateButtonsTitles()
    }
    
    settings.onColumnAmountChanged = { [weak self] newColumns in
      guard let `self` = self else {
        return
      }
      self.inputSource.numberOfColumns = newColumns
      self.updateCollection()
    }
    
    settings.onKeyboardChanged = { [weak self] newKeyboard in
      guard let `self` = self else {
        return
      }
      self.inputSource.currentKeyboard = newKeyboard
      self.updateCollection()
    }
    
    
    prevButton.titleLabel?.textAlignment = .center
    nextButton.titleLabel?.textAlignment = .center
    prevButton.titleLabel?.numberOfLines = 2
    nextButton.titleLabel?.numberOfLines = 2
    
    self.updateButtonsTitles()
    
    
    motionManagerHandleQueue = OperationQueue()
    motionManagerHandleQueue.maxConcurrentOperationCount = 1
    motionManagerHandleQueue.name = "CMMotionManager.Updates"
    motionManager = CMMotionManager()
    
    motionManagerFlushBufferTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (t) in
        guard t.isValid else { return }
        
        self?.motionManagerHandleQueue.addOperation({ [weak self] in
            if let min = self?.motionManagerUpdatesBuffer.min(), let max = self?.motionManagerUpdatesBuffer.max() {
                guard (max - min) > 0.18 else { return }
                
                self?.throttler?.throttle {
                    DispatchQueue.main.async {
                        if min < 0 { //move right
                            self?.prevButton.sendActions(for: .touchUpInside)
                        } else { //move left
                            self?.nextButton.sendActions(for: .touchUpInside)
                        }
                    }
                }
            }
            self?.motionManagerUpdatesBuffer = []
        })
    }
    
    motionManager.startAccelerometerUpdates(to: motionManagerHandleQueue) { [weak self] (data, error) in
        guard let data = data else { return }
        
        self?.motionManagerUpdatesBuffer.append(data.acceleration.y)
    }
    
    motionManager.accelerometerUpdateInterval = 0.2
    
    throttlingInterval = 2
  }
  
  private func updateCollection() {
    inputLayout.prepare()
    inputCollection.reloadData()
    inputCollection.setCollectionViewLayout(self.inputLayout, animated: false)
    inputCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
    updateButtonsTitles()
  }
  
  private func updateButtonsTitles() {
    let currentSection = Int(roundf(Float(inputCollection.contentOffset.x / inputCollection.frame.width)))
    let totalSections = inputSource.sections.count
    let nextSection = (currentSection + 1) % totalSections
    let prevSection = (currentSection - 1 + totalSections) % totalSections
    let titleProduce: ((Int) -> String) = { sectionNumber -> String in
      let values = self.inputSource.sections[sectionNumber].values
      if values.count < 5 {
        return values.joined(separator: ",")
      }
      return [values.prefix(2), ["..."], values.suffix(1)].flatMap({ $0 }).joined(separator: ",")
    }
    
    prevButton.setTitle("⬅️\n" + titleProduce(prevSection).uppercased(), for: .normal)
    nextButton.setTitle("➡️\n" + titleProduce(nextSection).uppercased(), for: .normal)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    inputSource.reload()
    inputCollection.reloadData()
    inputCollectionProcessor.scrollsToMiddleSection(inputCollection)
    inputField.becomeFirstResponder()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    let visibleIndex = inputCollection.indexPathsForVisibleItems.min()
    coordinator.animate(
      alongsideTransition: nil,
      completion: { [weak self] (context) in
        self?.inputLayout.prepare()
        if let nIndexPath = visibleIndex {
          self?.inputCollection.reloadData()
          self?.inputCollection.scrollToItem(at: nIndexPath, at: .left, animated: false)
        }
    })
  }
}


public class Throttler {
    
    private let queue: DispatchQueue = DispatchQueue.global(qos: .background)
    
    private var job: DispatchWorkItem = DispatchWorkItem(block: {})
    private var previousRun: Date = Date.distantPast
    private var maxInterval: Int
    
    init(seconds: Int) {
        self.maxInterval = seconds
    }
    
    
    func throttle(block: @escaping () -> ()) {
        job.cancel()
        job = DispatchWorkItem(){ [weak self] in
            self?.previousRun = Date()
            block()
        }
        let delay = Date.second(from: previousRun) > maxInterval ? 0 : maxInterval
        queue.asyncAfter(deadline: .now() + Double(delay), execute: job)
    }
}

private extension Date {
    static func second(from referenceDate: Date) -> Int {
        return Int(Date().timeIntervalSince(referenceDate).rounded())
    }
}
