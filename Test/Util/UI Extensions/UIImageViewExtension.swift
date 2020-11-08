//
//  UIImageViewExtension.swift
//  Test
//
//  Created by Astghik Hakopian on 11/6/20.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(url: URL?, indicatorType: IndicatorType = .activity) {
        guard let url = url else { return }
        
        kf.indicatorType = indicatorType
        kf.setImage(with: url)
    }
}


