//
//  InsertScoreTableViewCell.swift
//  godori
//
//  Created by KP on 2018-03-29.
//  Copyright © 2018 KP. All rights reserved.
//

import UIKit

class InsertScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pibakButton: DetailBakButton!
    @IBOutlet weak var kwangbakButton: DetailBakButton!
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButtons()
    }
    
    func setupButtons() {
        pibakButton.setTitle("피박", for: .normal)
        kwangbakButton.setTitle("광박", for: .normal)
        
        setupDefaultStatusForButton(button: pibakButton, color: .godoriPink)
        setupDefaultStatusForButton(button: kwangbakButton, color: .godoriPurple)
    }
    
    func setupDefaultStatusForButton(button: DetailBakButton, color: UIColor) {
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 2.0
        button.layer.borderColor = color.cgColor
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = .white
        
        button.isEnabled = false
    }

    @IBAction func pibakAction(_ sender: Any) {
        if pibakButton.isPressed {
            pibakButton.setTitleColor(UIColor.godoriPink, for: .normal)
            pibakButton.backgroundColor = UIColor.white
            pibakButton.isPressed = false
        } else {
            pibakButton.setTitleColor(UIColor.white, for: .normal)
            pibakButton.backgroundColor = UIColor.godoriPink
            pibakButton.isPressed = true
        }
    }
    
    @IBAction func kwangbakAction(_ sender: Any) {
        if kwangbakButton.isPressed {
            kwangbakButton.setTitleColor(UIColor.godoriPurple, for: .normal)
            kwangbakButton.backgroundColor = UIColor.white
            kwangbakButton.isPressed = false
        } else {
            kwangbakButton.setTitleColor(UIColor.white, for: .normal)
            kwangbakButton.backgroundColor = UIColor.godoriPurple
            kwangbakButton.isPressed = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

// Custom Button Class for pibak and gwangbak
class DetailBakButton: UIButton {
    
    var isPressed: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
