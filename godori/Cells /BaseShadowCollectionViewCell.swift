//
//  BaseShadowCollectionViewCell.swift
//  godori
//
//  Created by KP on 2018-04-24.
//  Copyright © 2018 KP. All rights reserved.
//

import UIKit

class BaseShadowCollectionViewCell: UICollectionViewCell {
    
    let cornerRadius: CGFloat = 14.0
    let innerMargin: CGFloat = 20.0
    private weak var shadowView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureShadow()
    }
    
    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: innerMargin,
                                              y: innerMargin,
                                              width: bounds.width - (2 * innerMargin),
                                              height: bounds.height - (2 * innerMargin)))
        
        let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: cornerRadius)
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowRadius = 8.0
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.25
        shadowView.layer.shadowPath = shadowPath.cgPath
        
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
    }
    
    
}
