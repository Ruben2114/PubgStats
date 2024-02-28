//
//  PieChartView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 5/7/23.
//

import Foundation
import UIKit
import Combine

typealias PieChartPaths = (sector: CategoryRepresentable, path: UIBezierPath)
typealias PieChartSector = (sector: CategoryRepresentable, startAngle: CGFloat, endAngle: CGFloat)

class PieChartView: UIView {
    private var representable: PieChartViewDataRepresentable?
    private var subjectButton = PassthroughSubject<Void, Never>()
    public var publisherButton: AnyPublisher<Void, Never> {
        return subjectButton.eraseToAnyPublisher()
    }
    
    private var categories: [CategoryRepresentable] = []
    private let graphDiameter: CGFloat = 212
    private let unsetIndex: Int = -1
    private let minSectorPercentage: Double = 2.0
    private let innerCircleDiameter: CGFloat = 156.0
    let arcWidth: CGFloat = 28.0
    var graphRadius: CGFloat { graphDiameter / 2 }
    var paths = [PieChartPaths]()
    var sectors = [PieChartSector]()
    var viewCenter: CGPoint { CGPoint(x: bounds.midX, y: bounds.midY) }
    var drawSteps: [(() -> Void)] = []
    private var innerRadius: CGFloat {
        return innerCircleDiameter/2
    }
    var innerCircle: UIBezierPath {
        UIBezierPath(arcCenter: self.viewCenter,
                     radius: self.innerCircleDiameter/2,
                     startAngle: -.pi * 0.3,
                     endAngle: 2 * .pi, clockwise: true)
    }
   
    private var centerIcon: UIImage?
    var currentCenterTitleText: String?
    var currentSubTitleText: String?
    private var centerTitleLabel: UILabel {
        let label = UILabel(frame: .zero)
        label.text = currentCenterTitleText ?? representable?.centerTitleText
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    private var centerDescriptionLabel: UILabel {
        let bottomLabel = UILabel(frame: .zero)
        bottomLabel.text = currentSubTitleText ?? representable?.centerSubtitleText
        bottomLabel.textColor = .white
        bottomLabel.font = UIFont.systemFont(ofSize: 14)
        bottomLabel.textAlignment = .center
        bottomLabel.numberOfLines = 2
        bottomLabel.adjustsFontSizeToFitWidth = true
        bottomLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        bottomLabel.widthAnchor.constraint(lessThanOrEqualToConstant: innerRect.width).isActive = true
        return bottomLabel
    }
    
    private lazy var stackViewCenter: UIStackView = {
        let view = UIStackView(frame: CGRect(centeredOn: viewCenter, size: CGSize(width: innerRect.width, height: innerRect.height)))
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.spacing = 0
        view.alignment = .center
        view.axis = .vertical
        view.center = viewCenter
        view.distribution = .fillProportionally
        return view
    }()
    
    private lazy var buttonCenter: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var totalImage: UIImageView {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        image.contentMode = .scaleAspectFit
        image.image = centerIcon
        return image
    }
    
    private var innerRect: CGRect {
        let side = ((innerCircleDiameter*innerCircleDiameter) / 2).squareRoot()
        return CGRect(x: viewCenter.x, y: viewCenter.y, width: side, height: side)
    }

    override func draw(_ rect: CGRect) {
        if UIGraphicsGetCurrentContext() != nil {
            paths.removeAll()
            drawSteps.forEach { step in step() }
        }
    }
    
    func build() {
        self.drawSteps = [
            setSectors,
            drawPaths,
            drawInnerCircle,
            getCenterStackView
        ]
    }
    
    func setChartInfo(_ representable: PieChartViewDataRepresentable) {
        self.categories = representable.categories
        self.representable = representable
        self.centerIcon = UIImage(systemName: representable.centerIconKey)
    }
    
    func getPathColor(for category: CategoryRepresentable) -> UIColor {
        category.color
    }
}

private extension PieChartView {
    func drawPaths() {
        paths.forEach {
            getPathColor(for: $0.sector).setFill()
            $0.path.addLine(to: viewCenter)
            $0.path.fill()
        }
    }
    
    func setSectors() {
        self.getAnglesInfo(for: categories)
    }
    
    func drawInnerCircle() {
        UIColor.black.setFill()
        innerCircle.fill()
    }
    
    func getCenterStackView() {
        for subview in stackViewCenter.arrangedSubviews {
            stackViewCenter.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        let titleLabel = centerTitleLabel
        addSubview(stackViewCenter)
        stackViewCenter.addArrangedSubview(totalImage)
        stackViewCenter.addArrangedSubview(titleLabel)
        stackViewCenter.addArrangedSubview(centerDescriptionLabel)
        addSubview(buttonCenter)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: stackViewCenter.centerYAnchor),
            
            buttonCenter.topAnchor.constraint(equalTo: stackViewCenter.topAnchor),
            buttonCenter.leadingAnchor.constraint(equalTo: stackViewCenter.leadingAnchor, constant: 20),
            buttonCenter.trailingAnchor.constraint(equalTo: stackViewCenter.trailingAnchor, constant: -20),
            buttonCenter.bottomAnchor.constraint(equalTo: stackViewCenter.bottomAnchor)
        ])
    }
    
    func getAnglesInfo(for sectors: [CategoryRepresentable]) {
        let smallSectors = sectors.filter { $0.percentage < minSectorPercentage }
        let largeSectors = sectors.filter { $0.percentage >= minSectorPercentage }
        let offset = (minSectorPercentage * Double(smallSectors.count)) - (smallSectors.map { $0.percentage }.reduce(0, +))
        let sectorOffset = offset / Double(largeSectors.count)
        var anglesInfo: [PieChartSector] = []
        var startAngle: CGFloat = (.pi * 3) / 2
        for sector in sectors {
            let arc = sector.percentage < minSectorPercentage ? minSectorPercentage : (sector.percentage - sectorOffset)
            let endAngle = startAngle + (CGFloat(arc) * (.pi * 2.0) / 100.0)
            defer { startAngle = endAngle }
            let pieSector = (sector: sector, startAngle: startAngle, endAngle: endAngle)
            anglesInfo.append(pieSector)
            appendArcPath(for: pieSector)
        }
        self.sectors = anglesInfo
    }
    
    func getRepresentedPercentageInCircle(of value: CGFloat, in totalValue: CGFloat) -> CGFloat {
        return ((.pi * 2.0) * value) / totalValue
    }
    
    func appendArcPath(for sector: PieChartSector) {
        let path = UIBezierPath(arcCenter: viewCenter, radius: graphRadius, startAngle: sector.startAngle, endAngle: sector.endAngle, clockwise: true)
        paths.append((sector: sector.sector, path: path))
    }
    
    @objc func buttonAction(_ gesture: UITapGestureRecognizer) {
        subjectButton.send()
    }
}


