//
//  UIViewController+Ext.swift
//  SmartFootballTips
//
//  Created by Petar Radev on 22.06.20.
//  Copyright © 2020 Petar Radev. All rights reserved.
//

import UIKit

extension UIViewController {
    static func classByIdentifier(_ storyboard : String, identifier : String) -> UIViewController {
        return UIStoryboard.init(name: storyboard, bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
    }
    
    func showDialogWithAction(title: String, message: String, action: Consts.VoidClosure?) {
        let popup = UIAlertController.init(
            title: title,
            message: message,
            preferredStyle: .alert)
        popup.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
            if let action = action {
                action()
            }
        }))
        self.present(popup, animated: true, completion: nil)
    }
    
    func onErrorGeneric(_ error: Error) {
        
        switch error as! ErrorMessage {
        case .invalidData(let err):
            showDialogWithAction(title: "Error", message: err, action: nil)
        case .networkFailure(_):
            showDialogWithAction(
                title: "No connection",
                message: "Our servers cannot be reached. Please check your connectivity and try again.",
                action: {
                    self.viewDidLoad()
            })
        }
    }
}
