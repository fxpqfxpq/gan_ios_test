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
    
    let occupationStr = "Occupation:"
    let statusStr = "Status:"
    let nicknameStr = "Nickname:"
    let seasonAppearancesStr = "Season appearances:"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let character = character {
            navigationItem.title = character.name
            
            if let escaped = character.img.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
                let url = URL.init(string: escaped) {
                
                image.sd_imageIndicator = SDWebImageActivityIndicator.gray
                image.sd_setImage(with: url, placeholderImage: UIImage(named: "Breaking_Bad_logo"))
            }
            
            let formattedOccupationText = (character.occupation.map{String($0)}).joined(separator: ", ")
            occupationLabel.text = "\(occupationStr) \(formattedOccupationText)"
            
            statusLabel.text = "\(statusStr) \(character.status)"
            nicknameLabel.text = "\(nicknameStr) \(character.nickname)"
            
            let formattedSeasonAppearanceText = (character.appearance.map{String($0)}).joined(separator: ", ")
            seasonAppearanceLabel.text = "\(seasonAppearancesStr) \(formattedSeasonAppearanceText)"
        }
    }
    
    deinit {
        print("CharacterDetailsViewController deinit")
    }
}
