//
//  UIViewExtension.swift
//  Test
//
//  Created by Astghik Hakopian on 11/8/20.
//

import UIKit

extension UIView {
    
    func fixInView(_ container: UIView, inset: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: inset.left).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: -inset.right).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: inset.top).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: -inset.bottom).isActive = true
    }
}
