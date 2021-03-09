//
//  AttribTextHolder.swift
//  SmartFootballTips
//
//  Created by Petar Radev on 23.06.20.
//  Copyright © 2020 Petar Radev. All rights reserved.
//

import UIKit

class AttribTextHolder {
    
    enum AttrType {
        case link
        case color
        case fontSize
    }

    let originalText: String
    var attributes: [(text: String, type: AttrType, value: Any)]


    init(text: String, attrs: [(text: String, type: AttrType, value: Any)] = []) {
        originalText = text
        attributes = attrs
    }

    func addAttr(_ attr: (text: String, type: AttrType, value: Any)) -> AttribTextHolder {
        attributes.append(attr)
        return self
    }

    func setTo(textView: UITextView) {
        let style = NSMutableParagraphStyle()
        style.alignment = .center

        let attributedOriginalText = NSMutableAttributedString(string: originalText)

        for item in attributes {
            let arange = attributedOriginalText.mutableString.range(of: item.text)
            switch item.type {
            case .link:
                let urlString = item.value as! String
                if let urlEncodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: urlEncodedStr) {
                    attributedOriginalText.addAttribute(.link, value: url, range: arange)
                } else {
                    attributedOriginalText.addAttribute(.link, value: urlString, range: arange)
                }
            case .color:
                var color = UIColor.black
                if let c = item.value as? UIColor { color = c }
                else if let s = item.value as? String { color = s.color() }
                attributedOriginalText.addAttribute(
                    NSAttributedString.Key.foregroundColor, value: color, range: arange)
            case .fontSize:
                let fontSize = item.value as! Double
                
                attributedOriginalText.addAttribute(
                    .font, value: UIFont.systemFont(ofSize: CGFloat(fontSize)), range: arange)
            }
        }

        let fullRange = NSMakeRange(0, attributedOriginalText.length)
        attributedOriginalText.addAttribute(.paragraphStyle, value: style, range: fullRange)

        textView.linkTextAttributes = [
            kCTForegroundColorAttributeName: UIColor.blue,
//            kCTUnderlineStyleAttributeName: NSUnderlineStyle.single.rawValue,
        ] as [NSAttributedString.Key : Any]

        textView.attributedText = attributedOriginalText
    }
}
