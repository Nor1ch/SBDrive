//
//  ModalTransition.swift
//  Diplom
//
//  Created by Nor1 on 08.07.2022.
//

import UIKit

class ModalTransition : Transition {
    func open(_ viewController: UIViewController, from: UIViewController, completion: (() -> Void)?) {
        viewController.modalPresentationStyle = .fullScreen
        from.present(viewController, animated: true, completion: completion)
    }
    
    func close(_ viewController: UIViewController, completion: (() -> Void)?) {
        viewController.dismiss(animated: true, completion: completion)
    }
    
    
}
