//
//  BetterUILabel.swift
//
//  Created by Adriano Paladini on 06/09/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

extension UILabel {
    public func set(text _text: String?, duration: TimeInterval) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: { () -> Void in
            self.text = _text
        }, completion: nil)
    }
}
