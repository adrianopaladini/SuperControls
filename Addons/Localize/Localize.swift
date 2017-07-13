//
//  Localize.swift
//
//  Created by Adriano Paladini on 06/09/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

class Localize {
    static var current: String {
        get {
            let saved: String? = UserDefaults.standard.string(forKey: "manualLanguage")
            let fromOS: String = Bundle.main.preferredLocalizations.first ?? "Base"
            return saved ?? fromOS
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "manualLanguage")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "multiLanguageUpdated"), object: nil)
        }
    }
    static func resetToDefault() {
        UserDefaults.standard.removeObject(forKey: "manualLanguage")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "multiLanguageUpdated"), object: nil)
    }
    static var available: [String] {
        return Bundle.main.localizations as [String]
    }
    static func name(_ language: String) -> String {
        let locale: NSLocale = NSLocale(localeIdentifier: language)
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return ""
    }
}
public extension String {
    var localized: String {
        var path = Bundle.main.path(forResource: Localize.current, ofType: "lproj")
        if path == nil {
            path = Bundle.main.path(forResource: "Base", ofType: "lproj")
        }
        if let bundle = Bundle(path: path!) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        return self
    }
    mutating func setValue(_ args: CVarArg...) {
        for (index, arg) in args.enumerated() {
            self = self.replacingOccurrences(of: "%\(index)", with: "\(arg)")
        }
    }
}






public protocol Localizable: class {
    var localizableProperty: String? { get set }
    var localizableString: String { get set }
}
extension Localizable{
    public func applyLocalizableString(_ localizableString: String?) -> Void {
        self.localizableProperty = localizableString?.localized
        localizationSetup()
    }
    public func getLocalizableProperty() -> String {
        guard let text = self.localizableProperty else {
            return ""
        }
        return text
    }
    func localizationSetup(){
        //let sel = #selector(updateLocalizationFromNotification)
        //NotificationCenter.default.addObserver(self, selector: sel, name: NSNotification.Name(rawValue: "multiLanguageUpdated"), object: nil)
    }
}
extension UIButton: Localizable {
    public var localizableProperty: String?{
        get{ return self.currentTitle }
        set{ self.setTitle(newValue, for: UIControlState()) }
    }
    @IBInspectable public var localizableString: String{
        get { return getLocalizableProperty() }
        set { applyLocalizableString(newValue) }
    }
}
extension UILabel: Localizable {
    public var localizableProperty: String?{
        get{ return self.text }
        set{ self.text = newValue }
    }
    @IBInspectable public var localizableString: String{
        get { return getLocalizableProperty() }
        set { applyLocalizableString(newValue) }
    }
}
extension UINavigationItem: Localizable {
    public var localizableProperty: String?{
        get{ return self.title }
        set{ self.title = newValue }
    }
    @IBInspectable public var localizableString: String{
        get { return getLocalizableProperty() }
        set { applyLocalizableString(newValue) }
    }
}
extension UITextField: Localizable {
    public var localizableProperty: String?{
        get{ return self.placeholder }
        set{ self.placeholder = newValue }
    }
    @IBInspectable public var localizableString: String{
        get { return getLocalizableProperty() }
        set { applyLocalizableString(newValue) }
    }
}
extension UITextView: Localizable{
    public var localizableProperty: String?{
        get{ return self.text }
        set{ self.text = newValue }
    }
    @IBInspectable public var localizableString: String{
        get { return getLocalizableProperty() }
        set { applyLocalizableString(newValue) }
    }
}
extension UIBarItem: Localizable {
    public var localizableProperty: String?{
        get{ return self.title }
        set{ self.title = newValue }
    }
    @IBInspectable public var localizableString: String{
        get { return getLocalizableProperty() }
        set { applyLocalizableString(newValue) }
    }
}
extension UISearchBar: Localizable {
    public var localizableProperty: String?{
        get{ return self.placeholder }
        set{ self.placeholder = newValue }
    }
    @IBInspectable public var localizableString: String{
        get { return getLocalizableProperty() }
        set { applyLocalizableString(newValue) }
    }
}

