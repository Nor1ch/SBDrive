//
//  TableViewSubviews.swift
//  Diplom
//
//  Created by Nor1 on 26.08.2022.
//

import Foundation
import UIKit

class TableViewSubviews : UITableView {
    override func layoutSubviews() {
        if (self.window == nil) {
            return
        } else {
            super.layoutSubviews()
        }
    }
}
