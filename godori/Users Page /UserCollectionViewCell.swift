//
//  UserCollectionViewCell.swift
//  godori
//
//  Created by KP on 2018-03-21.
//  Copyright © 2018 KP. All rights reserved.
//
//  Shadow code from AppStoreClone by Phillip Farrugia

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    private let cornerRadius: CGFloat = 14.0
    private let innerMargin: CGFloat = 20.0

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    private weak var shadowView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureUserImageViewLayer()
        configureUserNameLabelLayer()
        configureShadow()
    }
    
    // MARK: Layer Configurations
    
    private func configureUserImageViewLayer() {
        let imageViewMaskPath = UIBezierPath(roundedRect: userImageView.bounds, cornerRadius: cornerRadius)
        let imageViewMask = CAShapeLayer()
        imageViewMask.frame = userImageView.bounds
        imageViewMask.path = imageViewMaskPath.cgPath
        userImageView.layer.mask = imageViewMask
    }
    
    private func configureUserNameLabelLayer() {
        let userNameLabelMaskPath = UIBezierPath(roundedRect: userNameLabel.bounds,
                                                 byRoundingCorners: [.bottomLeft, .bottomRight],
                                                 cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let userNameLabelMask = CAShapeLayer()
        userNameLabelMask.frame = userNameLabel.bounds
        userNameLabelMask.path = userNameLabelMaskPath.cgPath
        userNameLabel.layer.mask = userNameLabelMask
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
