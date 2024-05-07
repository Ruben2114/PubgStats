//
//  PercentageRectangleRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 4/3/24.
//

import UIKit

protocol PercentageRectangleRepresentable {
    var text: String? { get }
    var percentage: CGFloat { get }
    var backgroundColor: UIColor? { get }
    var cornerRadius: CGFloat? { get }
    var withText: Bool? { get }
    var withPercentageSymbol: Bool? { get }
}

struct DefaultPercentageRectangle: PercentageRectangleRepresentable {
    var text: String?
    var percentage: CGFloat
    var backgroundColor: UIColor?
    var cornerRadius: CGFloat?
    var withText: Bool?
    var withPercentageSymbol: Bool?
    
    init(text: String? = "", percentage: CGFloat, backgroundColor: UIColor? = .black, cornerRadius: CGFloat? = 0, withText: Bool? = true, withPercentageSymbol: Bool? = true) {
        self.text = text
        self.percentage = percentage
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.withText = withText
        self.withPercentageSymbol = withPercentageSymbol
    }
}
