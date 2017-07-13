//
//  BetterUITextView.swift
//
//  Created by Adriano Paladini on 06/09/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

extension UITextView {
    public func addDoneButton(_ barStyle: UIBarStyle = .default, title: String? = nil) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: title ?? "Done", style: .done, target: self, action: #selector(resignFirstResponder))
        ]
        
        keyboardToolbar.barStyle = barStyle
        keyboardToolbar.sizeToFit()
        
        inputAccessoryView = keyboardToolbar
    }
}
