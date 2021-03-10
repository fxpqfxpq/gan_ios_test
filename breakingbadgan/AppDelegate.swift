//
//  AppDelegate.swift
//  breakingbadgan
//
//  Created by Petar Radev on 9.03.21.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var disposeBag = DisposeBag()
    
    static func sharedDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    static func openCharactersVC() {
        let vc = UIViewController.classByIdentifier("Main", identifier: "MainNavController")
        AppDelegate.sharedDelegate().window?.rootViewController = vc
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        AppDelegate.openCharactersVC()
        
        return true
    }
}

