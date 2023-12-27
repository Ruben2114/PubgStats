//
//  ExtensionPieChart.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 7/7/23.
//

import Foundation
import UIKit

//TODO: refactor con protocol y struct
struct PieChartViewData {
    var centerIconKey: String
    var centerTitleText: String
    var centerSubtitleText: String
    var categories: [CategoryRepresentable]
    var tooltipLabelTextKey: String
}

struct CategoryRepresentable {
    var percentage: Double
    var color: UIColor
    var secundaryColor: UIColor
    var currentCenterTitleText: String
    var currentSubTitleText: String
    var iconUrl: String
}
