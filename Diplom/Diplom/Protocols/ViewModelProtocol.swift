//
//  ViewModelProtocol.swift
//  Diplom
//
//  Created by Nor1 on 22.07.2022.
//

import Foundation

protocol ViewModelProtocol {
    func updateDataSource()
    func didSelectFileAt(_ indexPath: IndexPath)
    func removeFileAt(_ indexPath: IndexPath)
}
