//
//  Async.swift
//
//  Created by Adriano Paladini on 06/09/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

class Async {
    private var result = true
    private let asyncGroup = DispatchGroup()
    typealias MethodHandler = () -> Void
    func all(_ funct: [MethodHandler], _ completion: @escaping (Bool) -> Void) {
        self.result = true
        for f in funct {
            asyncGroup.enter()
            f()
        }
        asyncGroup.notify(queue: DispatchQueue.main, execute: {
            completion(self.result)
        })
    }
    func resolve() {
        asyncGroup.leave()
    }
    func reject() {
        result = false
        asyncGroup.leave()
    }
}

