//
//  Transition.swift
//  Diplom
//
//  Created by Nor1 on 08.07.2022.
//

import UIKit

protocol Transition: AnyObject {
    func open(_ viewController: UIViewController, from: UIViewController, completion: (() -> Void)?)
    func close(_ viewController: UIViewController, completion: (() -> Void)?)
}
