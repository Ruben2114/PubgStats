//
//  ExtensionPieChart.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 7/7/23.
//

import Foundation
import UIKit

//TODO: refactor con protocol y struct

protocol PieChartViewDataRepresentable {
    var centerIconKey: String { get }
    var centerTitleText: String { get }
    var centerSubtitleText: String { get }
    var categories: [CategoryRepresentable] { get }
    var tooltipLabelTextKey: String { get }
    var bottomSheetKey: (String, String) { get }
}

struct DefaultPieChartViewData: PieChartViewDataRepresentable {
    let centerIconKey: String
    let centerTitleText: String
    let centerSubtitleText: String
    let categories: [CategoryRepresentable]
    let tooltipLabelTextKey: String
    let bottomSheetKey: (String, String)
    
    init(centerIconKey: String, centerTitleText: String, centerSubtitleText: String, categories: [CategoryRepresentable], tooltipLabelTextKey: String, bottomSheetKey: (String, String)) {
        self.centerIconKey = centerIconKey
        self.centerTitleText = centerTitleText
        self.centerSubtitleText = centerSubtitleText
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
    var icon: String { get }
}

struct DefaultCategory: CategoryRepresentable {
    let percentage: Double
    let color: UIColor
    let secundaryColor: UIColor
    let currentCenterTitleText: String
    let currentSubTitleText: String
    let icon: String
    
    init(percentage: Double, color: UIColor, secundaryColor: UIColor, currentCenterTitleText: String, currentSubTitleText: String, icon: String) {
        self.percentage = percentage
        self.color = color
        self.secundaryColor = secundaryColor
        self.currentCenterTitleText = currentCenterTitleText
        self.currentSubTitleText = currentSubTitleText
        self.icon = icon
    }
}
