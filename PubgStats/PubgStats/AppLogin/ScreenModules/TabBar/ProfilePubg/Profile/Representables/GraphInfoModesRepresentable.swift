//
//  GraphInfoModesRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/12/23.
//

protocol GraphInfoModesRepresentable {
    var firstGraph: DoubleChartBarAdapterRepresentable { get }
    var secondGraph: DoubleChartBarAdapterRepresentable { get }
    var thirdGraph: DoubleChartBarAdapterRepresentable { get }
}

struct DefaultGraphInfoModes: GraphInfoModesRepresentable {
    var firstGraph: DoubleChartBarAdapterRepresentable
    var secondGraph: DoubleChartBarAdapterRepresentable
    var thirdGraph: DoubleChartBarAdapterRepresentable
    
    init(firstGraph: DoubleChartBarAdapterRepresentable, secondGraph: DoubleChartBarAdapterRepresentable, thirdGraph: DoubleChartBarAdapterRepresentable) {
        self.firstGraph = firstGraph
        self.secondGraph = secondGraph
        self.thirdGraph = thirdGraph
    }
}

