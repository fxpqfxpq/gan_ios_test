//
//  CharacterCell.swift
//  breakingbadgan
//
//  Created by Petar Radev on 10.03.21.
//

import UIKit
import MaterialComponents

class CharacterCell: UITableViewCell {
    
    @IBOutlet weak var cardView: MDCCard!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cardView.cornerRadius = 8.0
        self.cardView.setShadowElevation(ShadowElevation(rawValue: 2.0), for: .normal)
        characterNameLabel.textColor = .textDarkPrimary
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
