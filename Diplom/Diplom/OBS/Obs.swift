//
//  Obs.swift
//  Diplom
//
//  Created by Nor1 on 15.07.2022.
//

import Foundation

class Obs<T> {
    typealias Listener = (T) -> Void
    private var listener: Listener?
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    var value: T {
        didSet {
            listener?(value)
        }
    }
    init(_ v: T) {
        value = v
    }
}
