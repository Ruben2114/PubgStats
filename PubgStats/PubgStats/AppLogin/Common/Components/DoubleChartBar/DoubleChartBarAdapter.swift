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
    @IBOutlet private weak var baselineView: UIView!
    @IBOutlet private weak var firstBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var secondBarHeightConstraint: NSLayoutConstraint!
    private var viewData: DoubleChartBarAdapterViewData?
    private let minBarHeight: CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public func configureView(_ viewData: DoubleChartBarAdapterViewData) {
        self.viewData = viewData
        setViewData()
    }
}

private extension DoubleChartBarAdapter {
    func setupView() {
        setAppearance()
        secondBarContainerView.isHidden = true
    }
    
    func setAppearance() {
        firstBarView.roundCorners(corners: [.topLeft, .topRight], radius: 4)
        secondBarView.roundCorners(corners: [.topLeft, .topRight], radius: 4)
        baselineView.backgroundColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.00)
    }
    
    func setViewData() {
        viewData?.secondBarValue == nil ? setSimpleBar() : setDoubleBar()
    }
    
    func setSimpleBar() {
        secondBarContainerView.isHidden = true
        firstBarView.backgroundColor = viewData?.barsColor
        firstBarHeightConstraint.constant = barsStackView.frame.height
        layoutIfNeeded()
    }
    
    func setDoubleBar() {
        guard let viewData,
              let secondValue = viewData.secondBarValue?.doubleValue.doubleRounded()
        else { return }
        secondBarContainerView.isHidden = false
        let mostPositiveValue =  max(viewData.firstBarValue.doubleValue.doubleRounded(), secondValue)
        let mostNegativeValue =  min(viewData.firstBarValue.doubleValue.doubleRounded(), secondValue)
        let maxValue = viewData.isNegativeValues ? mostNegativeValue : mostPositiveValue
        let maxHeight = barsStackView.frame.height
        let firstBarHeight = (viewData.firstBarValue.doubleValue.doubleRounded() / maxValue) * maxHeight
        let secondBarHeight = (secondValue / maxValue) * maxHeight
        if maxValue != 0 {
            firstBarHeightConstraint.constant = firstBarHeight > 2 ? firstBarHeight : minBarHeight
            secondBarHeightConstraint.constant = secondBarHeight > 2 ? secondBarHeight : minBarHeight
        } else {
            firstBarHeightConstraint.constant = minBarHeight
            secondBarHeightConstraint.constant = minBarHeight
        }
        layoutIfNeeded()
        firstBarView.backgroundColor = viewData.barsColor
        secondBarView.backgroundColor = viewData.barsColor.diagonalPatternColor(size: secondBarView.frame.size)
    }
}

extension UIView {
    @discardableResult
    func roundCorners(corners: UIRectCorner,
                      radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        return mask
    }
}

extension Double {
    func doubleRounded(toPlaces places: Int = 2) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Decimal {
    public var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
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

public protocol DoubleChartBarAdapterViewData {
    var firstBarValue: Decimal { get }
    var secondBarValue: Decimal? { get }
    var barsColor: UIColor { get }
    var isNegativeValues: Bool { get }
}

public protocol DoubleChartBarAdapterIdentifier {
    var suffixAccessibilityIdentifier: String? { get }
}

public protocol DoubleChartBarAdapterAccessibilityInfo {
    var firstBarAccessibilityLabel: String { get }
    var secondBarAccessibilityLabel: String? { get }
}

struct DefaultDoubleChartBarAdapterViewData: DoubleChartBarAdapterViewData {
    let firstBarValue: Decimal
    let secondBarValue: Decimal?
    let barsColor: UIColor
    let isNegativeValues: Bool
    
    init(firstBarValue: Decimal, secondBarValue: Decimal?, barsColor: UIColor, isNegativeValues: Bool) {
        self.firstBarValue = firstBarValue
        self.secondBarValue = secondBarValue
        self.barsColor = barsColor
        self.isNegativeValues = isNegativeValues
    }
}
