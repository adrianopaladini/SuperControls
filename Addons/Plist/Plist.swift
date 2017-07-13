//
//  Plist.swift
//
//  Created by Adriano Paladini on 06/09/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

class Plist {
    static func load(_ file: String, _ key: String) -> String {
        var resourceFileDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: file, ofType: "plist") {
            resourceFileDictionary = NSDictionary(contentsOfFile: path)
        }
        if let resourceFileDictionaryContent = resourceFileDictionary {
            if let value = resourceFileDictionaryContent.object(forKey: key) {
                return "\(value)"
            }
        }
        return ""
    }
}
