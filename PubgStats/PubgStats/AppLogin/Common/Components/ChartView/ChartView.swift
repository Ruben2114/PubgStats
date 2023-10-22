//
//  ChartView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 12/7/23.
//

import UIKit

final class ChartView: UIView {
    private lazy var interactiveChart: InteractiveSectoredPieChartView = {
        return InteractiveSectoredPieChartView()
    }()
    private lazy var tooltipImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "star")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private lazy var tooltipLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    func setCellInfo(_ data: PieChartViewData) {
        setAppearance()
        setConstrait()
        interactiveChart.setChartInfoInteractive(data)
        tooltipLabel.text = data.tooltipLabelTextKey
        interactiveChart.build()
    }
}

private extension ChartView {
    func setAppearance() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        interactiveChart.backgroundColor = .clear
    }
    
    func setConstrait() {
        interactiveChart.translatesAutoresizingMaskIntoConstraints = false
        addSubview(interactiveChart)
        interactiveChart.topAnchor.constraint(equalTo: topAnchor).isActive = true
        interactiveChart.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        interactiveChart.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(tooltipImageView)
        tooltipImageView.topAnchor.constraint(equalTo: interactiveChart.bottomAnchor).isActive = true
        tooltipImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        addSubview(tooltipLabel)
        tooltipLabel.topAnchor.constraint(equalTo: interactiveChart.bottomAnchor).isActive = true
        tooltipLabel.leadingAnchor.constraint(equalTo: tooltipImageView.trailingAnchor, constant: 10).isActive = true
        tooltipLabel.trailingAnchor.constraint(equalTo: interactiveChart.trailingAnchor, constant: -10).isActive = true
        tooltipLabel.bottomAnchor.constraint(equalTo: bottomAnchor,  constant: -10).isActive = true
    }
}
