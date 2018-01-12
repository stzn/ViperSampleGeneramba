//
//  AlertShowable.swift
//  ViperSampleGeneramba
//
//  Created by stakata on 2018/01/07.
//  Copyright © 2018年 officekoma. All rights reserved.
//

import UIKit

protocol AlertShowable {
    func showAlert(with title: String?, message: String?)
    func showErrorAlert(with message: String)
}

extension AlertShowable where Self: UIViewController {
    func showAlert(with title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(with: title, message: message, actions: [okAction])
    }
    
    func showErrorAlert(with message: String) {
        Alert.shared.alert(title: "エラー", message: message)
    }
    
    func showAlert(with title: String?, message: String?, actions: [UIAlertAction]? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        
        if let actions = actions {
            actions.forEach { action in
                controller.addAction(action)
            }
        } else {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
            controller.addAction(okAction)
        }
        
        self.present(controller, animated: true, completion: nil)
        
        return
    }
}
