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
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCharacters: [Character] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()

        let request = ServerRequest<CharactersRequest>.init(data: CharactersRequest.init())
        viewModel.getCharacters(charactersRequest: request).subscribe(onNext: { [weak self] (characters) in
            guard let strongSelf = self else { return }
            strongSelf.onSuccess(characters)
        }, onError: { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.onError(error)
        }).disposed(by: AppDelegate.sharedDelegate().disposeBag)
    }
    
    deinit {
        print("CharactersViewController deinit")
    }
    
    // MARK: - Private methods
    
    private func onSuccess(_ characters: [Character]?) {
        if let characters = characters {
            print("Characters: \(characters)")
            filteredCharacters = characters
            tableView.reloadData()
        }
    }
    
    private func onError(_ error: Error) {
        print("Failed to get characters with error: \(error)")
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func filterContentForSearchText(
        _ searchText: String,
        category: String? = nil
    ) {
        if let characters = viewModel.characters {
            filteredCharacters = characters.filter { (character: Character) -> Bool in
                return character.name.lowercased().contains(searchText.lowercased())
            }
            
            tableView.reloadData()
        }
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
        if isFiltering {
            return filteredCharacters.count
        }
        
        return viewModel.characters?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CharacterCell", for: indexPath) as? CharacterCell
        if let character = viewModel.characters?[indexPath.row] {
            setupCharacterCell(cell: cell, character: character)
        }
        
        return cell ?? CharacterCell()
    }
}

extension CharactersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
