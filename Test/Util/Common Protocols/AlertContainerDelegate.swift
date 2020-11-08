//
//  AlertContainerDelegate.swift
//  Test
//
//  Created by Astghik Hakopian on 11/6/20.
//

import UIKit

struct AlertAction {
    let buttonTitle: String
    let handler: (() -> Void)?
    let style: UIAlertAction.Style
    
    init(buttonTitle: String, handler: (() -> Void)?, style: UIAlertAction.Style = .default) {
        self.buttonTitle = buttonTitle
        self.handler = handler
        self.style = style
    }
}

struct SingleButtonAlert {
    let title: String
    let message: String
    let action: AlertAction
}

protocol AlertContainerDelegate where Self: UIViewController {
    func present(alert: SingleButtonAlert)
}

extension AlertContainerDelegate {
    func present(alert: SingleButtonAlert) {
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: alert.action.buttonTitle, style: alert.action.style, handler: { _ in alert.action.handler?() })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
