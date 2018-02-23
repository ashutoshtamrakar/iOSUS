//
//  Bindable.swift
//  TechnicalTest
//
//  Created by AT on 21/02/18.
//  Copyright © 2018 UbiqueSystems. All rights reserved.
//

import Foundation

final class Bindable<T> {
    
    typealias Listener = ((T) -> Void)
    var listener: Listener?
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        self.value = v
    }
}
