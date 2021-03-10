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
    let segmentedControl: UISegmentedControl = UISegmentedControl.init(items: ["All", "S1",  "S2", "S3", "S4", "S5" ])
    
    var filteredCharacters: [Character] = []
    var segmentCharacters: [Character] = []
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
        setupSegmentedControl()

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
            segmentCharacters = characters
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
    
    private func setupSegmentedControl() {
        segmentedControl.backgroundColor = .colorPrimary
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.white]
        let selectedAttributes: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.colorPrimary]
        segmentedControl.setTitleTextAttributes(attributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
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
    
    private func filterSegmentCharacters(segmentIndex: Int) {
        if let characters = viewModel.characters {
            if segmentIndex == 0 {
                segmentCharacters = characters
            } else {
                segmentCharacters = characters.filter({ (character: Character) -> Bool in
                    return character.appearance.contains(segmentIndex)
                })
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
    
    @objc func segmentedValueChanged(_ sender: UISegmentedControl!) {
        let selectedSegment = sender.selectedSegmentIndex
        print("Selected Segment Index is : \(selectedSegment)")
        
        filterSegmentCharacters(segmentIndex: selectedSegment)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCharacters.count
        }
        
        return segmentCharacters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CharacterCell", for: indexPath) as? CharacterCell
        
        var character: Character?
        
        if isFiltering {
            character = filteredCharacters[indexPath.row]
        } else {
            character = segmentCharacters[indexPath.row]
        }
        
        if let character = character {
            setupCharacterCell(cell: cell, character: character)
        }
        
        return cell ?? CharacterCell()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let viewHeader = UIView.init(frame: CGRect(
                x: 0,
                y: 0,
                width: self.view.bounds.width - 40,
                height: 24))
            viewHeader.backgroundColor = .clear
            
            segmentedControl.frame = CGRect(
                x: 20,
                y: 0,
                width: viewHeader.frame.size.width,
                height: viewHeader.frame.size.height)
            viewHeader.addSubview(segmentedControl)
            
            return viewHeader
        }
        
        return nil
    }
}

extension CharactersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
