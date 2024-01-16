//
//  DoubleChartBarAdapter.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 19/10/23.
//

import UIKit
import Foundation

public final class DoubleChartBarAdapter: XibView {
    @IBOutlet private weak var barsStackView: UIStackView!
    @IBOutlet private weak var secondBarContainerView: UIView!
    @IBOutlet private weak var firstBarView: UIView!
    @IBOutlet private weak var secondBarView: UIView!
    @IBOutlet private weak var firstBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var secondBarHeightConstraint: NSLayoutConstraint!
    private var viewData: DoubleChartBarAdapterRepresentable?
    private let minBarHeight: CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public func configureView(_ viewData: DoubleChartBarAdapterRepresentable?) {
        self.viewData = viewData
        setDoubleBar()
    }
}

private extension DoubleChartBarAdapter {
    func setupView() {
        firstBarView.roundCorners(corners: [.topLeft, .topRight], radius: 4)
        secondBarView.roundCorners(corners: [.topLeft, .topRight], radius: 4)
    }
    
    func setDoubleBar() {
        guard let viewData else { return }
        let mostPositiveValue =  max(viewData.firstBarValue, viewData.secondBarValue)
        let maxHeight = barsStackView.frame.height
        let firstBarHeight = maxHeight * (CGFloat(viewData.firstBarValue * 100 / mostPositiveValue)) / 100
        let secondBarHeight = maxHeight * (CGFloat(viewData.secondBarValue * 100 / mostPositiveValue)) / 100
        if mostPositiveValue != 0 {
            firstBarHeightConstraint.constant = firstBarHeight > 2 ? firstBarHeight : minBarHeight
            secondBarHeightConstraint.constant = secondBarHeight > 2 ? secondBarHeight : minBarHeight
        } else {
            firstBarHeightConstraint.constant = minBarHeight
            secondBarHeightConstraint.constant = minBarHeight
        }
        layoutIfNeeded()
        firstBarView.backgroundColor = .systemBlue
        secondBarView.backgroundColor = .systemBlue.diagonalPatternColor(size: secondBarView.frame.size)
    }
}

extension UIColor {
    public func diagonalPatternColor(size: CGSize,
                                     lineSpacing: CGFloat = 5.5,
                                     lineWidth: CGFloat = 1,
                                     lineAngle: CGFloat = -56) -> UIColor {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.withAlphaComponent(0.2).cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        context?.setStrokeColor(self.cgColor)
        context?.setLineWidth(lineWidth)

        let angleInRadians = lineAngle * .pi / 180.0
        let diagonalLength = sqrt(pow(size.width, 2) + pow(size.height, 2))

        for x in stride(from: -diagonalLength, through: diagonalLength, by: lineSpacing) {
            let yStart = x * tan(angleInRadians)
            let yEnd = yStart + diagonalLength * tan(angleInRadians)
            context?.move(to: CGPoint(x: 0, y: yStart))
            context?.addLine(to: CGPoint(x: diagonalLength, y: yEnd))
        }

        context?.strokePath()
        let patternImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return UIColor(patternImage: patternImage ?? UIImage())
    }
}
