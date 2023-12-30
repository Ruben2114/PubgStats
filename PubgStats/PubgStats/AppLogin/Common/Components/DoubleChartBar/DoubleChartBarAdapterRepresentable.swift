//
//  DoubleChartBarAdapterViewData.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/12/23.
//

import Foundation

public protocol DoubleChartBarAdapterRepresentable {
    var firstBarValue: Int { get }
    var secondBarValue: Int { get }
}

struct DefaultDoubleChartBarAdapter: DoubleChartBarAdapterRepresentable {
    let firstBarValue: Int
    let secondBarValue: Int
    
    init(firstBarValue: Int, secondBarValue: Int) {
        self.firstBarValue = firstBarValue
        self.secondBarValue = secondBarValue
    }
}
