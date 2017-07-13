//
//  BetterUITextField.swift
//
//  Created by Adriano Paladini on 06/09/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

@IBDesignable class BetterUITextField: UITextField {
    open var bottomLine = UIView()
    open var titleLabel = UILabel()
    open var errorLabel = UILabel()
    open var spinner = UIActivityIndicatorView()
    private let red = UIColor(red:0.77, green:0.32, blue:0.25, alpha:1.00)
    private var cachedLineColor: UIColor = UIColor.clear
    private var cachedSelectedLineColor: UIColor = UIColor.clear
    @IBInspectable var title: String {
        set { titleLabel.text = newValue }
        get { return titleLabel.text ?? "" }
    }
    @IBInspectable var isAlphanumeric: Bool = false
    @IBInspectable var lineColor: UIColor {
        set {
            self.cachedLineColor = newValue
            updateColors()
        }
        get { return self.cachedLineColor }
    }
    @IBInspectable var selectedLineColor: UIColor {
        set {
            self.cachedSelectedLineColor = newValue
            updateColors()
        }
        get { return self.cachedSelectedLineColor }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
    @objc func setUpView() {
        addLine()
        createTitleLabel()
        createErrorLabel()
    }
    func loading(_ value: Bool) {
        if value {
            self.spinner.color = cachedSelectedLineColor
            self.addSubview(self.spinner)
            self.spinner.frame = CGRect(x: self.frame.width - 30, y: 6, width: 30, height: 30)
            self.spinner.startAnimating()
        } else {
            self.spinner.stopAnimating()
            self.spinner.removeFromSuperview()
        }
    }
    private func updateColors() {
        if super.isEditing {
            self.bottomLine.backgroundColor = cachedSelectedLineColor
        } else {
            self.bottomLine.backgroundColor = cachedLineColor
        }
        self.titleLabel.textColor = cachedSelectedLineColor
        self.errorLabel.text = ""
    }
    @discardableResult override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        updateColors()
        updateTitleVisibility()
        return result
    }
    @discardableResult override open func resignFirstResponder() -> Bool {
        let result =  super.resignFirstResponder()
        updateColors()
        updateTitleVisibility()
        if self.isAlphanumeric {
            filterChars()
        }
        return result
    }
    private func filterChars() {
        self.text = self.text?.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    }
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        //super.textRect(forBounds: bounds)
        let rect = CGRect(
            x: 0,
            y: 18, // titleHeight() + 4,
            width: bounds.size.width - 30,
            height: bounds.size.height - 20 //(titleHeight() + 20)
        )
        return rect
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: 0,
            y: 18, //titleHeight() + 4,
            width: bounds.size.width - 30,
            height: bounds.size.height - 20 //(titleHeight() + 20)
        )
        return rect
    }
    private func titleHeight() -> CGFloat {
        return self.titleLabel.font.lineHeight * 0.7
    }
    private func originalTitleHeight() -> CGFloat {
        return self.titleLabel.font.lineHeight
    }
    private func createTitleLabel() {
        self.titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.titleLabel.font = UIFont.systemFont(ofSize: 17)
        self.titleLabel.alpha = 1.0
        self.titleLabel.textColor = cachedLineColor
        self.titleLabel.text = self.title
        self.titleLabel.frame = CGRect(x: -(self.bounds.size.width / 2),
                                       y: 4,
                                       width: self.bounds.size.width,
                                       height: originalTitleHeight())
        self.titleLabel.layer.anchorPoint = CGPoint.zero
        addSubview(self.titleLabel)
        self.animateOut(0)
    }
    private func createErrorLabel() {
        self.errorLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.errorLabel.font = UIFont.systemFont(ofSize: 11)
        self.errorLabel.alpha = 1.0
        self.errorLabel.textColor = red
        self.errorLabel.text = ""
        self.errorLabel.adjustsFontSizeToFitWidth = true
        self.errorLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.errorLabel)
        self.errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.errorLabel.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    private func updateTitleVisibility() {
        if super.isEditing {
            animateIn()
        } else {
            if self.text == "" {
                animateOut()
            }
        }
    }
    public func error(_ message: String? = nil) {
        self.bottomLine.backgroundColor = red
        self.titleLabel.textColor = red
        if message != nil {
            self.errorLabel.text = message ?? ""
        }
    }
    public func setText(_ text: String) {
        self.text = text
        manualUpdateTitle()
    }
    public func manualUpdateTitle() {
        if self.text == "" {
            animateOut()
        } else {
            animateIn()
        }
    }
    private func animateIn() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            self.titleLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.titleLabel.textColor = self.cachedSelectedLineColor
            self.bottomLine.backgroundColor = self.cachedSelectedLineColor
            self.titleLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.titleHeight())
        })
    }
    private func animateOut(_ duration: Double = 0.3) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.titleLabel.textColor = self.cachedLineColor
            self.bottomLine.backgroundColor = self.cachedLineColor
            self.titleLabel.frame = CGRect(x: 0,
                                           y: 14,
                                           width: self.bounds.size.width,
                                           height: self.originalTitleHeight())
        })
    }
    private func addLine() {
        self.bottomLine.backgroundColor = cachedLineColor
        self.bottomLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.bottomLine)
        self.bottomLine.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        self.bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
}
private var maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = maxLengths[self] else {
                return 0 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if maxLength != 0 {
            let t = textField.text
            textField.text = t?.safelyLimitedTo(length: maxLength)
        }
    }
}
extension String {
    func safelyLimitedTo(length num: Int) -> String {
        let c = self.characters
        if c.count <= num { return self }
        return String( Array(c).prefix(upTo: num) )
    }
}
