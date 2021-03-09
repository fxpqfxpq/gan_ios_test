//
//  CharactersViewModel.swift
//  breakingbadgan
//
//  Created by Petar Radev on 9.03.21.
//

import Foundation

import Foundation
import RxSwift

class CharactersViewModel {
    let disposeBag = DisposeBag()
    
    var characters: [Character]?
    
    func getCharacters(charactersRequest: ServerRequest<CharactersRequest>) -> Observable<[Character]?> {
        return Observable.create { observable -> Disposable in
            AppContent.shared.fetch(service: .getCharacters(charactersRequest: charactersRequest)).subscribe({ (event) in
                self.parseEvent(event: event, observable: observable)
            })
        }
    }
    
    // MARK: - Private methods
    
    private func parseEvent(event: Event<Any?>, observable: AnyObserver<[Character]?>) {
        if let e = event.error {
            observable.onError(ErrorMessage.networkFailure(error: e.localizedDescription))
        } else {
            if let characters = event.element as? [Character] {
                self.characters = characters
                observable.onNext(characters)
            } else {
                print("Failed to get characters, invalid data returned from server - DATA: \(String(describing: event.element))")
                observable.onError(ErrorMessage.invalidData(
                    error: "Invalid predictions response returned from server"))
            }
        }
    }
}
