//
//  InteractiveSectoredPieChartView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 5/7/23.
//

import UIKit
import Foundation
import Combine

final class InteractiveSectoredPieChartView: PieChartView {
    private typealias SectorStatus = (index: Int, status: PieChartViewSectorStatus)
    private enum PieChartViewSectorStatus: Comparable { case notSet, none, selected }
    private enum Config {
        static let unsetIndex: Int = -1
        static let notSetSector: SectorStatus = (Config.unsetIndex, .notSet)
        static let noneSector: SectorStatus = (Config.unsetIndex, .none)
    }
    
    private var selectedSector: SectorStatus = Config.notSetSector
    private var sectorViews = [UIView]()
    private var subscriptions: Set<AnyCancellable> = []
    
    override func build() {
        super.build()
        drawSteps.append(drawSelectionArc)
    }
    
    override func getPathColor(for category: CategoryRepresentable) -> UIColor {
        self.resolveColorFor(category: category, color: category.color)
    }
    
    func setChartInfoInteractive(_ representable: PieChartViewDataRepresentable) {
        super.setChartInfo(representable)
        bindButton()
    }
    
    func didTapNewView(_ gesture: UIPanGestureRecognizer) {
        let point: CGPoint = gesture.location(in: self)
        for sectorPath in paths where sectorPath.path.contains(point) && !innerCircle.contains(point) {
            selectSectorFor(index: getIndexFor(category: sectorPath.sector))
            return
        }
        selectSectorFor(index: -1)
    }
}

private extension InteractiveSectoredPieChartView {
    func getMidAngle(between startAngle: CGFloat, and endAngle: CGFloat) -> CGFloat {
        return (startAngle + endAngle) / 2
    }
    
    func getIndexFor(category: CategoryRepresentable) -> Int {
        sectors.firstIndex {
            category.color == $0.sector.color
        } ?? Config.unsetIndex
    }
    
    @objc func didSelectSector(_ gesture: UITapGestureRecognizer) {
        guard let index = (gesture.view)?.tag else { return }
        selectSectorFor(index: index)
    }
    
    func selectSectorFor(index: Int) {
        selectedSector = index == Config.unsetIndex ? Config.noneSector : (index, .selected)
        if selectedSector.status == .selected {
            let sector = sectors[index].sector
            currentCenterTitleText = sector.currentCenterTitleText
            currentSubTitleText = sector.currentSubTitleText
        } else {
            currentCenterTitleText = nil
            currentSubTitleText = nil
        }
        setNeedsDisplay()
    }
    
    func resolveColorFor(category: CategoryRepresentable, color: UIColor) -> UIColor {
        let index = getIndexFor(category: category)
        switch selectedSector.status {
        case .notSet, .none:
            return category.color
        case .selected:
            return selectedSector.index == index ? color : category.color
        }
    }
    
    func drawSelectionArc() {
        let selectionArcWidth: CGFloat = 4
        sectors.forEach {
            let path = UIBezierPath(arcCenter: viewCenter, radius: graphRadius - selectionArcWidth/2, startAngle: $0.startAngle, endAngle: $0.endAngle, clockwise: true)
            path.lineWidth = selectionArcWidth
            resolveColorFor(category: $0.sector, 
                            color: UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1))
            .setStroke()
            path.stroke()
        }
        
    }
    
    func bindButton() {
        publisherButton
            .sink { [weak self] in
                self?.selectSectorFor(index: -1)
        }.store(in: &subscriptions)
    }
}

