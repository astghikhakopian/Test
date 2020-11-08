//
//  AppColor.swift
//  Test
//
//  Created by Astghik Hakopian on 11/9/20.
//

import UIKit

struct AppColor {
    
    static let backgrund: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return .white
        }
    }()
    
    static let oppositeBackgrund: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return .black
        }
    }()
}
