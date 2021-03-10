//
//  CharactersTableViewController.swift
//  breakingbadgan
//
//  Created by Petar Radev on 10.03.21.
//

import UIKit
import SDWebImage

class CharactersTableViewController: UITableViewController {

    private let viewModel = CharactersViewModel()
    

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = ServerRequest<CharactersRequest>.init(data: CharactersRequest.init())
        viewModel.getCharacters(charactersRequest: request).subscribe(onNext: { [weak self] (characters) in
            guard let strongSelf = self else { return }
            strongSelf.onSuccess(characters)
        }, onError: { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.onError(error)
        }).disposed(by: AppDelegate.sharedDelegate().disposeBag)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    deinit {
        print("CharactersViewController deinit")
    }
    
    // MARK: - Private methods
    
    private func onSuccess(_ characters: [Character]?) {
        print("Characters: \(characters ?? [])")
        tableView.reloadData()
    }
    
    private func onError(_ error: Error) {
        print("Failed to get characters with error: \(error)")
    }
    
    private func setupCharacterCell(cell: CharacterCell?,  character: Character) {
        cell?.characterNameLabel.text = character.name
    
        if let escaped = character.img.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let url = URL.init(string: escaped) {
            
            cell?.characterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell?.characterImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "Breaking_Bad_logo"))
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CharacterCell", for: indexPath) as? CharacterCell
        print("DA IBA MUHATA")
        if let character = viewModel.characters?[indexPath.row] {
            setupCharacterCell(cell: cell, character: character)
        }
        
        return cell ?? CharacterCell()
    }
}
