//
//  BetterUIButton.swift
//
//  Created by Adriano Paladini on 06/09/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

@IBDesignable class BetterUIButton: UIButton {
    var loader: Bool = false
    var oldtitle: String = ""
    var indicatorArea: UIView?
    var indicator: UIActivityIndicatorView?
    var tempColor: UIColor?
    var tempWidth: NSLayoutConstraint?
    @IBInspectable var borderColor: UIColor? {
        set { layer.borderColor = newValue!.cgColor }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            } else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get { return layer.cornerRadius }
    }
    @IBInspectable var useLoader: Bool {
        set { loader = newValue }
        get { return loader }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
    func setUpView() {
        self.clipsToBounds = true
        if !self.loader { return }
        self.oldtitle = self.title(for: .normal) ?? ""
        tempColor = self.backgroundColor
        self.backgroundColor = UIColor.clear
        indicatorArea = UIView()
        indicatorArea?.isUserInteractionEnabled = false
        indicatorArea?.layer.cornerRadius = self.layer.cornerRadius
        indicatorArea?.backgroundColor = tempColor
        indicatorArea?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicatorArea!)
        indicatorArea?.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        indicatorArea?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicatorArea?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        tempWidth = indicatorArea?.widthAnchor.constraint(equalToConstant: self.frame.width)
        tempWidth?.isActive = true
        let frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
        indicator = UIActivityIndicatorView(frame: frame)
        indicator?.color = self.currentTitleColor
        indicatorArea?.addSubview(indicator!)
    }
    func loading(_ show: Bool) {
        if !self.loader { return }
        if self.isEnabled == false && show {
            return
        }
        if show {
            self.isEnabled = false
            self.setTitle("", for: .normal)
            indicator?.startAnimating()
            tempWidth?.constant = self.frame.height
            UIView.animate(withDuration: 0.3) {
                self.alpha = 0.5
                self.layoutSubviews()
            }
        } else {
            self.isEnabled = true
            indicator?.stopAnimating()
            self.setTitle(self.oldtitle, for: .normal)
            tempWidth?.constant = self.frame.width
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1.0
                self.layoutSubviews()
            }
        }
    }
}
