//
//  BetterUIView.swift
//
//  Created by Adriano Paladini on 06/09/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

extension UISwitch {
    public func toggle() {
        self.setOn(!self.isOn, animated: true)
    }
}
