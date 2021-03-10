//
//  CharacterDetailsViewController.swift
//  breakingbadgan
//
//  Created by Petar Radev on 10.03.21.
//

import UIKit
import SDWebImage

class CharacterDetailsViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var seasonAppearanceLabel: UILabel!
    
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let character = character {
            navigationItem.title = character.name
            
            if let escaped = character.img.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
                let url = URL.init(string: escaped) {
                
                image.sd_imageIndicator = SDWebImageActivityIndicator.gray
                image.sd_setImage(with: url, placeholderImage: UIImage(named: "Breaking_Bad_logo"))
            }
            
            if let occupationText = occupationLabel.text {
                let formattedOccupationText = (character.occupation.map{String($0)}).joined(separator: ", ")
                occupationLabel.text = "\(occupationText) \(formattedOccupationText)"
            }
            
            if let statusText = statusLabel.text {
                statusLabel.text = "\(statusText) \(character.status)"
            }
            
            if let nicknameText = nicknameLabel.text {
                nicknameLabel.text = "\(nicknameText) \(character.nickname)"
            }
            
            if let seasonAppearanceText = seasonAppearanceLabel.text {
                let formattedSeasonAppearanceText = (character.appearance.map{String($0)}).joined(separator: ", ")
                seasonAppearanceLabel.text = "\(seasonAppearanceText) \(formattedSeasonAppearanceText)"
            }
        }
    }
    
    deinit {
        print("CharacterDetailsViewController deinit")
    }
}
