//
//  Utils.swift
//
//  Created by Adriano Paladini on 06/09/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

class Utils {
    public static func go(_ sender: UIViewController, _ window: String) {
        DispatchQueue.main.async(execute: {
            sender.performSegue(withIdentifier: window, sender: sender)
        })
    }
    public static func wait(_ seconds: Double, _ completion: @escaping() -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            completion()
        }
    }
    public static func viewFromXib(_ xib: String) -> UIView {
        let bundle = Bundle.main.loadNibNamed(xib, owner: nil, options: nil)
        let view = bundle?.first as? UIView
        return view ?? UIView()
    }
    
    public static var appDisplayName: String? {
        if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return bundleDisplayName
        } else if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return bundleName
        }
        
        return nil
    }
    
    public static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    public static var appBuild: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
    
    public static var appBundleID: String? {
        return Bundle.main.bundleIdentifier
    }
    
    public static var appVersionAndBuild: String? {
        if appVersion != nil && appBuild != nil {
            if appVersion == appBuild {
                return "v\(appVersion!)"
            } else {
                return "v\(appVersion!)(\(appBuild!))"
            }
        }
        return nil
    }
    
    public static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
    
    public static var isRelease: Bool {
        #if DEBUG
            return false
        #else
            return true
        #endif
    }
    
    public static var isSimulator: Bool {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return true
        #else
            return false
        #endif
    }
    
    public static var isDevice: Bool {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return false
        #else
            return true
        #endif
    }
    
    public static var isInTestFlight: Bool {
        return Bundle.main.appStoreReceiptURL?.path.contains("sandboxReceipt") == true
    }

    
    
}
