//
//  Session.swift
//  SmartFootballTips
//
//  Created by Petar Radev on 17.06.20.
//  Copyright © 2020 Petar Radev. All rights reserved.
//

import Foundation
import Moya
import KeychainSwift
import RxSwift

class UserSession {
    enum State {
        case unknown
        case loggedIn
        case termsNotAccepted
    }
    
    static let shared = UserSession()
    
    let keychain = KeychainSwift()
    var loggedIn: Observable<Bool>?
    var state: Variable<UserSession.State> = Variable(.unknown)
    
    private let disposeBag = DisposeBag()
    
    var storedSession: StoredSession? {
        get {
            if let d = keychain.getData(Consts.storedSessionObjectKey) {
                do {
                    let storedSession = try JSONDecoder.init().decode(StoredSession.self, from: d)
                    return storedSession
                } catch {
                    return nil
                }
            } else {
                return nil
            }
        }
    }
    
    init() {
        state.asObservable().subscribe(onNext: { (value) in
            switch value {
            case .loggedIn:
                print("LOGGED IN SUCCESSFULY")
                AppDelegate.openLobby()
                AppDelegate.sharedDelegate().didAppLaunch = true
            case .termsNotAccepted:
                print("TERMS NOT ACCEPTED")
                AppDelegate.openDisclaimer()
            case .unknown:
                print("USER NOT LOGGED IN")
            }
        }).disposed(by: disposeBag)
        
        // TODO: Figure out auto login when Ogi fucking finishes the fucking server
//        if let savedUser = user {
//            if let _ = savedUser.email {
//                state.value = .LoggedIn
//            } else {
//                state.value = .LoggedInGuest
//            }
//        } else {
//            state.value = .Unknown
//        }
    }
    
    func rememberLogin(_ sessionResponse: SessionResponse) {
        let storedSession = StoredSession(uuid: sessionResponse.uuid, token: sessionResponse.token)
        do {
            let storedSessionJSON = try JSONEncoder.init().encode(storedSession)
            keychain.set(storedSessionJSON, forKey: Consts.storedSessionObjectKey)
            if !sessionResponse.accepted_terms {
                state.value = .termsNotAccepted
            } else {
                state.value = .loggedIn
            }
        } catch {
            state.value = .unknown
        }
    }
    
    func updateStoredSessionToken(accessToken: String) -> Bool {
        if let storedSession = storedSession {
            let updatedStoredSession = StoredSession.init(uuid: storedSession.uuid, token: accessToken)
            do {
                let userJSON = try JSONEncoder.init().encode(updatedStoredSession)
                keychain.set(userJSON, forKey: Consts.storedSessionObjectKey)
                return true
            } catch {
                print("Failed to update user access token due to serialization error")
                return false
            }
        }
        
        return false
    }
    
    func userCredentialsSaved() -> Bool {
        if let _ = storedSession {
            return true
        } else {
            return false
        }
    }
    
    func logout() {
        keychain.delete(Consts.storedSessionObjectKey)
        state.value = .unknown
    }
}
