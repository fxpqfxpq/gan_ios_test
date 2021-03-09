//
//  Utils.swift
//  SmartFootballTips
//
//  Created by Petar Radev on 16.06.20.
//  Copyright © 2020 Petar Radev. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    static var _splashScreen : UIViewController?
    static var _errorScreen : UIViewController?
    static var iPhoneX:Bool {
        return UIScreen.main.bounds.size.height == 812
    }
    
    static func removeErrorScreen() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            _errorScreen?.view.removeFromSuperview()
        }
    }
    
    static func popupErrorScreen() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            _errorScreen = UIViewController.classByIdentifier("Main", identifier: "Error")
            AppDelegate.sharedDelegate().window!.rootViewController!.view.addSubview(_errorScreen!.view)
        }
    }
    
    static func showSplash(_ performActions : @escaping() -> Void) {
        _splashScreen = nil
        _splashScreen = UIViewController.classByIdentifier("Main", identifier: "Splash")
        AppDelegate.sharedDelegate().window!.rootViewController!.view.addSubview(Utils._splashScreen!.view)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            performActions()
        }
    }
    
    static func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    static func URLEncode(string: String) -> String {
        let generalDelimiters = ":#[]@ ?/"
        let subDelimiters = "!$&'()*+,;="
        
        let allowedCharacters = generalDelimiters + subDelimiters
        let customAllowedSet =  CharacterSet(charactersIn:allowedCharacters).inverted
        let escapedString = string.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
        
        return escapedString
    }
    
    
    static func hideSplash() {
        UIView.animate(withDuration: 0.4, animations: {
            if (Utils._splashScreen != nil) {
                AppDelegate.sharedDelegate().window!.rootViewController!.view.addSubview(Utils._splashScreen!.view)
            }
            _splashScreen?.view.alpha = 0
        }) { (finished) in
            if (finished) {
                _splashScreen?.view.removeFromSuperview()
                _splashScreen = nil
            }
        }
        
        
        //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
          //  _splashScreen?.view.removeFromSuperview()
       // }
    }
    
    static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func fileExist(path: String) -> Bool {
        var isDirectory: ObjCBool = false
        let fm = FileManager.default
        return (fm.fileExists(atPath: path, isDirectory: &isDirectory))
    }
    
    static func directoryExist(path: String) -> Bool {
        var isDirectory: ObjCBool = true
        let fm = FileManager.default
        return (fm.fileExists(atPath: path, isDirectory: &isDirectory))
    }

    static func writeToFile(fileURL: URL, writeText: String) -> Bool {
        do {
            try writeText.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Error: fileURL failed to write Text: \n\(error)" )
            return false
        }
        return true
    }
    
    static func writeToFile(fileURL: URL, writeData: Data) -> Bool {
        do {
            try writeData.write(to: fileURL)
        } catch let error as NSError {
            print("Error: fileURL failed to write Data: \n\(error)" )
            return false
        }
        return true
    }
      
    static func readFromFile(fileURL: URL, readText: inout String) -> Bool {
        if !(fileExist(path: fileURL.path)) {
            print("File does not exist...")
            return false
        }
      
        do {
            readText = try String(contentsOf: fileURL)
        } catch let error as NSError {
            print("Error: fileURL failed to read: \n\(error)" )
            return false
        }
        return true
    }
    
    static func createFile(fileURL: URL) -> Bool {
        if (fileExist(path: fileURL.path)) {
            print("File already exists...")
            return true
        }
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDir = paths.firstObject as! String
        print("Path to the Documents directory\n\(documentsDir)")

        
        return FileManager.default.createFile(atPath: fileURL.path,
                                              contents: nil,
                                              attributes: nil)
    }
    
    static func createDirectory(directoryURL: URL) -> Bool {
        if directoryExist(path: directoryURL.path) {
            print("Directory already exists...")
            return true
        }
        
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Error: fileURL failed to read: \n\(error)" )
            return false
        }
        return true
    }
    
    static func createFileAtPath(fileName: String, filePath: String, fileExt: String?) -> Bool {
        let filePathUrl = createUrl(urlName: filePath, fileExt: nil)
        let fileNameUrl = createUrl(urlName: fileName, fileExt: fileExt)
        
        if createDirectory(directoryURL: filePathUrl) {
            return createFile(fileURL: fileNameUrl)
        }
        
        return false
    }
    
    static func createUrl(urlName: String, fileExt: String?) -> URL {
        let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        print("documentsURL: " + String(describing: documentsURL))
        
        var fileURL = documentsURL.appendingPathComponent(urlName)
        if let fileExt = fileExt {
            fileURL = fileURL.appendingPathExtension(fileExt)
        }
        print("File Path: \(fileURL.path)")
        
        return fileURL
    }
    
    // NOTE!!! Chapters come in a reversed order from the server. Chapter one is
    // the last item of the array.
    static func createChaptersStrArr(chapters: String) -> [String] {
        let chaptersArr: [String] = chapters.components(separatedBy: "\n")
        var tempChaptersArr: [String] = []
        for item in chaptersArr {
            tempChaptersArr.append(item.trimmingCharacters(in: CharacterSet.newlines))
        }
        
        // Sometimes for some reason an empty chapter appears first, remove it
        if tempChaptersArr.last == "" {
            tempChaptersArr.removeLast()
        }
        
        return tempChaptersArr.reversed()
    }
    
    static func openUrl(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    static func createEncodedUrl(url: String) -> URL? {
        if let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedUrl) {
            return url
        }
        
        return nil
    }
    
    static func JSONResponseDataFormatter(_ data: Data) -> String {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
        } catch {
            return String(data: data, encoding: .utf8) ?? ""
        }
    }
}
