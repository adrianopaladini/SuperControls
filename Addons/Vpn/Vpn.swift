//
//  Vpn.swift
//
//  Created by Adriano Paladini on 06/09/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

class VPN {
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    public func isEdgeClientInstalled() -> Bool {
        if let url = URL(string: "f5edgeclient:") {
            return UIApplication.shared.canOpenURL(url)
        } else {
            return false
        }
    }
    public func verify(_ timeout: Int = 5, completion: @escaping (Bool) -> Void) {
        dataTask?.cancel()
        var request = URLRequest(url: URL(string: "\(Constants.apiUrl)status")!)
        request.timeoutInterval = TimeInterval(timeout)
        dataTask = defaultSession.dataTask(with: request) { _, response, _ in
            defer { self.dataTask = nil }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
        dataTask?.resume()
    }
}
