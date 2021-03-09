//
//  CharactersTableViewController.swift
//  breakingbadgan
//
//  Created by Petar Radev on 9.03.21.
//

import UIKit

class CharactersTableViewController: UITableViewController {

    private let viewModel = CharactersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = ServerRequest<CharactersRequest>.init(data: CharactersRequest.init())
        viewModel.getCharacters(charactersRequest: request).subscribe(onNext: { [weak self] (characters) in
            guard let strongSelf = self else { return }
            strongSelf.onSuccess(characters)
        }, onError: { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.onError(error)
        }).disposed(by: viewModel.disposeBag)
    }
    
    private func onSuccess(_ characters: [Character]?) {
        print("Characters: \(characters ?? [])")
    }
    
    private func onError(_ error: Error) {
        print("Failed to get characters with error: \(error)")
    }
    
    deinit {
        print("CharactersViewController deinit")
    }
}

