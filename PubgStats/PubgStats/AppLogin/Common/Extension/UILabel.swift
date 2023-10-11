//
//  UILabel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 12/7/23.
//

import UIKit

extension UILabel {
    func setTextLineBreak(key: String, value: String, fontSize: CGFloat){
        let keyAttibutes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let valueAttibutes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: fontSize, weight: .heavy)]
        
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: valueAttibutes)
        attributedText.append(NSAttributedString(string: key, attributes: keyAttibutes))
        
        self.attributedText = attributedText
    }
    
    func setTextLineBreak2(text: String, fontSize: CGFloat){
        let splitText = text.components(separatedBy:  "\n")
        let keyAttibutes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let valueAttibutes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: fontSize, weight: .heavy)]
        
        let attributedText = NSMutableAttributedString(string: "\(splitText.last ?? "")\n" , attributes: valueAttibutes)
        attributedText.append(NSAttributedString(string: splitText.first ?? "", attributes: keyAttibutes))
        
        self.attributedText = attributedText
    }
}
