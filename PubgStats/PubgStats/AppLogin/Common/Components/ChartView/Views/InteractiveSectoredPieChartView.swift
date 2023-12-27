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
    
    private var iconSize: CGFloat = 32.0
    private var selectedSector: SectorStatus = Config.notSetSector
    private var sectorViews = [UIView]()
    private var subscriptions: Set<AnyCancellable> = []
    
    override func build() {
        super.build()
        drawSteps.append(drawSelectionArc)
        drawSteps.append(addSectors)
    }
    
    override func getPathColor(for category: CategoryRepresentable) -> UIColor {
        self.resolveColorFor(category: category, color: category.color)
    }
    
    func setChartInfoInteractive(_ representable: PieChartViewData) {
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
    var distanceToIcon: CGFloat {
        let distanceFromArcToNonRotatedIconCenter: CGFloat = 12
        let iconDiagonal = sqrt((iconSize*iconSize) + (iconSize*iconSize))
        let normalDistance = distanceFromArcToNonRotatedIconCenter + iconSize/2
        let rotatedDistance = normalDistance - iconDiagonal/2
        let distanceFromArcToIcon = rotatedDistance + iconDiagonal/2
        let minimumDistance = graphRadius + distanceFromArcToIcon
        return minimumDistance
    }
    
    func addSectors() {
        guard selectedSector.status == .notSet else { return }
        drawSectorIcons()
    }
    
    func drawSectorIcons() {
        self.sectors.forEach { sector, startAngle, endAngle in
            let midAngle = getMidAngle(between: startAngle, and: endAngle)
            setIcon(in: sector, angle: midAngle)
        }
    }
    
    func setIcon(in category: CategoryRepresentable, angle: CGFloat) {
        let iconCenter =  CGPoint(x: bounds.midX + distanceToIcon * cos(angle), y: bounds.midY + distanceToIcon * sin(angle))
        let view = UIView(frame: CGRect(centeredOn: iconCenter, size: CGSize(width: iconSize, height: iconSize)))
        view.tag = getIndexFor(category: category)
        view.isUserInteractionEnabled = true
        view.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(didSelectSector(_:)))]
        self.addSubview(view)
        self.sectorViews.append(view)
        let imgView = UIImageView(frame: view.frame)
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(systemName: category.iconUrl)
        view.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imgView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imgView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imgView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
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
            return selectedSector.index == index ? color : category.secundaryColor
        }
    }
    
    func drawSelectionArc() {
        let selectionArcWidth: CGFloat = 4
        sectors.forEach {
            let path = UIBezierPath(arcCenter: viewCenter, radius: graphRadius - selectionArcWidth/2, startAngle: $0.startAngle, endAngle: $0.endAngle, clockwise: true)
            path.lineWidth = selectionArcWidth
            resolveColorFor(category: $0.sector, color: .black).setStroke()
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

