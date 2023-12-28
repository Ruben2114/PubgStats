//
//  DoubleChartBarAdapterViewData.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/12/23.
//

import Foundation

public protocol DoubleChartBarAdapterRepresentable {
    var firstBarValue: Double { get }
    var secondBarValue: Double { get }
}

struct DefaultDoubleChartBarAdapter: DoubleChartBarAdapterRepresentable {
    let firstBarValue: Double
    let secondBarValue: Double
    
    init(firstBarValue: Double, secondBarValue: Double) {
        self.firstBarValue = firstBarValue
        self.secondBarValue = secondBarValue
    }
}
