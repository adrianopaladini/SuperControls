//
//  NavigationProgress.swift
//
//  Created by Adriano Paladini on 06/09/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit


class NavProgressView: UIView {
    internal var percent: Float = 0.0
    internal var area = UIView()
    internal var bar = UIView()
    internal var barColor = UIColor(red:1.00, green:0.47, blue:0.31, alpha:1.0)
    internal var barWidthConstraint = NSLayoutConstraint()
    private func delayedProgress() {
        if self.percent >= 0.95 {
            return
        }
        var delay = 0.0
        switch self.percent {
        case 0..<0.4:
            self.percent += 0.03
            delay = 0.1
        case 0.4..<0.6:
            self.percent += 0.02
            delay = 0.2
        case 0.6..<0.9:
            self.percent += 0.01
            delay = 0.35
        case 0.9..<0.95:
            self.percent += 0.01
            delay = 0.5
        default:
            return
        }
        self.setProgress(self.percent, animated: true)
        Utils.wait(delay) {
            self.delayedProgress()
        }
    }
    func startIndeterminedProgress() {
        self.percent = 0.0
        self.delayedProgress()
    }
    func setProgress(_ progress: Float, animated: Bool) {
        self.bar.alpha = 1
        let duration: TimeInterval = animated ? 0.2 : 0
        self.barWidthConstraint.constant = self.area.bounds.width * CGFloat(progress)
        UIView.animate(withDuration: duration, animations: {
            self.area.layoutIfNeeded()
        })
    }
    func create(_ nav: UINavigationBar?) {
        if let Nav = nav {
            self.area.translatesAutoresizingMaskIntoConstraints = false
            self.bar.translatesAutoresizingMaskIntoConstraints = false
            self.bar.backgroundColor = barColor
            self.bar.alpha = 0
            Nav.addSubview(self.area)
            self.area.addSubview(self.bar)
            self.area.heightAnchor.constraint(equalToConstant: 4).isActive = true
            self.area.widthAnchor.constraint(equalTo: Nav.widthAnchor).isActive = true
            self.area.bottomAnchor.constraint(equalTo: Nav.bottomAnchor).isActive = true
            self.area.leadingAnchor.constraint(equalTo: Nav.leadingAnchor).isActive = true
            self.bar.topAnchor.constraint(equalTo: self.area.topAnchor).isActive = true
            self.bar.bottomAnchor.constraint(equalTo: self.area.bottomAnchor).isActive = true
            self.bar.leadingAnchor.constraint(equalTo: self.area.leadingAnchor).isActive = true
            self.barWidthConstraint = self.bar.widthAnchor.constraint(equalToConstant: 1)
            self.barWidthConstraint.isActive = true
        }
    }
    func destroy() {
        self.area.removeFromSuperview()
    }
    func finishProgress() {
        self.percent = 1
        self.barWidthConstraint.constant = self.area.bounds.width
        UIView.animate(withDuration: 0.1, animations: {
            self.area.layoutIfNeeded()
        }, completion: { _ in
            UIView.animate(withDuration: 0.25, animations: {
                self.bar.alpha = 0
            }, completion: { _ in
                self.barWidthConstraint.constant = 0
            })
        })
    }
    func cancelProgress() {
        self.percent = 1
        self.bar.layer.removeAllAnimations()
        self.setProgress(0, animated: true)
        UIView.animate(withDuration: 0.25, animations: {
            self.bar.alpha = 0
        })
    }
}
