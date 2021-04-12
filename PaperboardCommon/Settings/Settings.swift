//
//  Settings.swift
//  Paperboard
//
//  Created by Igor Zapletnev on 08.12.2020.
//  Copyright © 2020 Ice Rock. All rights reserved.
//

import Foundation

class Settings {
    struct Keyboard: Decodable {
        let voiceId: String
        let voiceName: String
        let alphabet: String
        let rightToLeft: Bool
        let locale: String
    }
    
    static let allSymbols: [Settings.Symbols] = [.numbers, .punctuation, .math, .currency, .extra]
    
    enum Symbols: String {
        case numbers = "numbers"
        case punctuation = "punctuation"
        case math = "math"
        case currency = "currency"
        case extra = "extra"
    }
    
    private let storage = SettingsStorage()
    
    var onColumnAmountChanged: [((Int) -> Void)] = []
    var onKeyboardChanged: [((Keyboard?) -> Void)] = []
    var onSymbolsChanged: [(([Symbols]) -> Void)] = []
    
    var keyboards: [Keyboard] = {
        let decoder = PropertyListDecoder()
        guard let plist = Bundle.main.url(forResource: "Keyboards", withExtension: "plist"),
              let data = try? Data(contentsOf: plist),
              let keyboards = try? decoder.decode([Keyboard].self, from: data) else {
            return []
        }
        return keyboards
    }()
    
    var currentColumns: Int {
        get {
            return (storage.getSettingValue(.columns) as? NSNumber)?.intValue ?? 3
        }
        set {
            storage.update(.columns, withValue: NSNumber(integerLiteral: newValue))
            onColumnAmountChanged.forEach { $0(newValue) }
        }
    }
    
    var currentKeyboard: Keyboard? {
        get {
            guard let locale = storage.getSettingValue(.locale) as? String else {
                return nil
            }
            return keyboards.first(where: { $0.locale == locale })
        }
        set {
            storage.update(.locale, withValue: newValue?.locale)
            onKeyboardChanged.forEach { $0(newValue) }
        }
    }
    
    var currentSymbols: [Symbols] {
        get {
            if let symbolsStr = storage.getSettingValue(.symbols) as? String {
                return symbolsStr.components(separatedBy: ",").map {
                    Symbols(rawValue: $0)
                }.compactMap { $0 }
            }
            return [Symbols.numbers, Symbols.punctuation]
        }
        set {
            let newValueStr = newValue.map { $0.rawValue }.joined(separator: ",")
            storage.update(.symbols, withValue: newValueStr)
            onSymbolsChanged.forEach { $0(newValue) }
        }
    }
    
    static func getSymbols(symbol: Symbols) -> [String] {
        switch symbol {
        case .numbers:
            return Array("1234567890").map{ String($0) }
        case .punctuation:
            return Array(",?;:”!()-").map{ String($0) }
        case .math:
            return Array("/*%^<>[]{}=+").map{ String($0) }
        case .currency:
            return Array("£$₽¥€฿₩₴").map{ String($0) }
        case .extra:
            return Array("§&#@|\\’~").map{ String($0) }
        default:
            return []
        }
    }
}
