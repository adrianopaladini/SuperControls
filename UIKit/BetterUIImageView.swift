//
//  BetterUIImageView.swift
//
//  Created by Adriano Paladini on 06/09/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

@IBDesignable class BetterUIImageView: UIImageView {
    
    private var urlSession: URLSessionDataTask?
    
    @IBInspectable var borderColor: UIColor? {
        set { layer.borderColor = newValue!.cgColor }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            return nil
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
    @IBInspectable var tintcolor: UIColor? {
        set { self.tintColor = newValue! }
        get {
            if let color = self.tintColor {
                return color
            }
            return nil
        }
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
    }
    
    func imageFromUrl(_ url: String, placeholder: UIImage? = nil, spinnerColor: UIColor? = nil) {
        self.urlSession?.cancel()
        if placeholder != nil {
            self.image = placeholder
        } else {
            self.image = nil
        }
        let rect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let spinner = UIActivityIndicatorView(frame: rect)
        if spinnerColor != nil {
            spinner.color = spinnerColor!
        }
        self.addSubview(spinner)
        if let image = self.loadCache(url: url) {
            self.image = image
        } else {
            spinner.startAnimating()
            self.urlSession = URLSession.shared.dataTask(with: NSURL(string: url)! as URL,
                                                         completionHandler: { (data, _, error) -> Void in
                if error != nil { return }
                if let myimage = UIImage(data: data!) {
                    self.saveCache(url: url, image: myimage)
                    DispatchQueue.main.async {
                        UIView.transition(with: self,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: { self.image = myimage },
                                          completion: nil)
                    }
                }
                DispatchQueue.main.async {
                    spinner.stopAnimating()
                }
            })
            self.urlSession?.resume()
        }
    }
    private func safeName(_ imgURL: String) -> String {
        return imgURL.replacingOccurrences(of: ":", with: "")
            .replacingOccurrences(of: "/", with: "")
            .replacingOccurrences(of: ".", with: "")
    }
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    private func saveCache(url: String, image: UIImage) {
        let imagePath = getDocumentsDirectory().appendingPathComponent(safeName(url))
        do {
            try UIImagePNGRepresentation(image)?.write(to: imagePath)
        } catch _ as NSError {}
    }
    private func loadCache(url: String) -> UIImage? {
        let imagePath = getDocumentsDirectory().appendingPathComponent(safeName(url)).path
        let fileManager = FileManager.default
        let exists = fileManager.fileExists(atPath: imagePath)
        if exists {
            let expirated = self.cacheExpirated(filePath: imagePath)
            if expirated {
                return nil
            } else {
                if let imageData: AnyObject = NSData(contentsOfFile:imagePath) {
                    let dat: NSData = (imageData as? NSData)!
                    return UIImage(data: dat as Data)!
                } else {
                    return nil
                }
            }
        } else {
            return nil
        }
    }
    private func cacheExpirated(filePath: String) -> Bool {
        do {
            let fileManager = FileManager.default
            let atributes = try fileManager.attributesOfItem(atPath: filePath)
            if let fileDate = atributes[FileAttributeKey.modificationDate] as? Date {
                let timeDiffDuration = Int(Date().timeIntervalSince(fileDate))
                if timeDiffDuration < 86400 { // 1 day
                    return false
                } else {
                    return true
                }
            } else {
                return true
            }
        } catch _ as NSError {
            return true
        }
    }
}
