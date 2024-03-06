//
//  ExtensionPieChart.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 7/7/23.
//

import Foundation
import UIKit

protocol PieChartViewDataRepresentable {
    var centerTitleText: String { get }
    var titletext: String { get }
    var categories: [CategoryRepresentable] { get }
    var tooltipLabelTextKey: String { get }
    var bottomSheetKey: (String, String) { get }
}

struct DefaultPieChartViewData: PieChartViewDataRepresentable {
    let centerTitleText: String
    let titletext: String
    let categories: [CategoryRepresentable]
    let tooltipLabelTextKey: String
    let bottomSheetKey: (String, String)
    
    init(centerTitleText: String, titletext: String, categories: [CategoryRepresentable], tooltipLabelTextKey: String, bottomSheetKey: (String, String)) {
        self.centerTitleText = centerTitleText
        self.titletext = titletext
        self.categories = categories
        self.tooltipLabelTextKey = tooltipLabelTextKey
        self.bottomSheetKey = bottomSheetKey
    }
}

protocol CategoryRepresentable {
    var percentage: Double { get }
    var color: UIColor { get }
    var secundaryColor: UIColor { get }
    var currentCenterTitleText: String { get }
    var currentSubTitleText: String { get }
}

struct DefaultCategory: CategoryRepresentable {
    let percentage: Double
    let color: UIColor
    let secundaryColor: UIColor
    let currentCenterTitleText: String
    let currentSubTitleText: String
    
    init(percentage: Double, color: UIColor, secundaryColor: UIColor, currentCenterTitleText: String, currentSubTitleText: String) {
        self.percentage = percentage
        self.color = color
        self.secundaryColor = secundaryColor
        self.currentCenterTitleText = currentCenterTitleText
        self.currentSubTitleText = currentSubTitleText
    }
}
