//
//  GamePlayUserCollectionViewCell.swift
//  godori
//
//  Created by KP on 2018-03-27.
//  Copyright © 2018 KP. All rights reserved.
//

import UIKit

class GamePlayUserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func calculateScoreAction(_ sender: Any) {
        
    }
}
