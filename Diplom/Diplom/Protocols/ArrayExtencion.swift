//
//  ArrayExtencion.swift
//  Diplom
//
//  Created by Nor1 on 10.11.2022.
//

import Foundation


extension Array where Element: Equatable {
    func all(where predicate: (Element) -> Bool) -> [Element] {
        return self.compactMap {predicate($0) ? $0 : nil}
    }
}
