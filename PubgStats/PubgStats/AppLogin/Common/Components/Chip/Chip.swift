//
//  Chip.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 19/10/23.
//

import Foundation
import UIKit
import Combine

public final class Chip: FlameXibButton {
    @IBOutlet private weak var roundedView: UIView!
    @IBOutlet private weak var leftImageView: UIImageView?
    @IBOutlet private weak var textLabel: UILabel?
    @IBOutlet private weak var rightImageView: UIImageView?
    
    private var subject = PassthroughSubject<Void, Never>()
    public lazy var publisher: AnyPublisher<Void, Never> = {
        return subject.eraseToAnyPublisher()
    }()
    
    var viewData: Chip.ViewData = ViewData(text: "",
                                           style: .active,
                                           type: .onlyText)
    
    var style: Chip.Style = .active {
        didSet {
            self.setStyleAppearance()
            if style == .disabled {
                self.isEnabled = false
            }
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            if oldValue != isEnabled {
                setEnabledApperance()
            }
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.configureView()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setCornerRadius()
    }
    
    func setViewData(viewData: ViewData) {
        self.viewData = viewData
        self.setLabels()
        self.setTypeAppearance()
        self.setCornerRadius()
        self.style = viewData.style
    }
    
    func setLeftImage(_ image: UIImage?) {
        self.leftImageView?.image = image?.withRenderingMode(.alwaysTemplate)
    }
}

private extension Chip {
    func configureView() {
        self.setRemoveIcon()
        self.leftImageView?.isHidden = true
        self.rightImageView?.isHidden = true
        self.roundedView.isUserInteractionEnabled = true
        self.roundedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapInsideChip)))
        self.setViewData(viewData: self.viewData)
    }
    
    func setEnabledApperance() {
        if isEnabled {
            self.setStyleAppearance()
        } else {
            self.style = .disabled
        }
    }
    
    func setAppearance() {
        self.setTypeAppearance()
        self.setStyleAppearance()
    }
    
    func setTypeAppearance() {
        self.textLabel?.sizeToFit()
        switch self.viewData.type {
        case .onlyText:
            self.rightImageView?.isHidden = true
            self.leftImageView?.isHidden = true
        case .withRightIcon:
            self.rightImageView?.isHidden = false
            self.leftImageView?.isHidden = true
        case .withIconLeft(leftIcon: let icon):
            self.setLeftImage(icon)
            self.rightImageView?.isHidden = true
            self.leftImageView?.isHidden = false
        case .withAllIcons(leftIcon: let icon):
            self.setLeftImage(icon)
            self.rightImageView?.isHidden = false
            self.leftImageView?.isHidden = false
        }
    }
    
    func setStyleAppearance() {
        self.setColorsAppearance()
        self.roundedView.layer.borderWidth = self.style.borderWidth()
        self.roundedView.layer.borderColor = UIColor(red: 0.075, green: 0.494, blue: 0.518, alpha: 1).cgColor
        self.style.setElevation(self)
    }
    
    func setColorsAppearance() {
        self.leftImageView?.tintColor = self.style.iconTintColor()
        self.rightImageView?.tintColor = self.style.iconTintColor()
        self.textLabel?.textColor = self.style.textColor()
        self.roundedView.backgroundColor = self.style.backgroundColor()
    }
    
    func setCornerRadius() {
        layoutIfNeeded()
        setNeedsLayout()
        self.roundedView.layer.cornerRadius = self.roundedView.frame.height/2
    }
    
    func setLabels() {
        self.textLabel?.text = self.viewData.text
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    func setRemoveIcon() {
        self.rightImageView?.image = UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate)
    }
    
    @objc func tapInsideChip() {
        subject.send()
    }
}

public extension Chip {
    enum Style {
        case active
        case disabled
    }
    
    struct ViewData {
        public var text: String
        public var style: Chip.Style
        public var type: ViewDataType
        
        public init(text: String,
                    style: Chip.Style = .active,
                    type: Chip.ViewDataType = .onlyText) {
            self.text = text
            self.style = style
            self.type = type
        }
    }
    
    enum ViewDataType {
        case onlyText
        case withRightIcon
        case withIconLeft(leftIcon: UIImage)
        case withAllIcons(leftIcon: UIImage)
    }
}

extension Chip.Style {
    func backgroundColor() -> UIColor {
        switch self {
        case .disabled: return UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1)
        default: return .white
        }
    }
    
    func textColor() -> UIColor {
        switch self {
        case .disabled: return UIColor(red: 0.800, green: 0.800, blue: 0.800, alpha: 1)
        default: return UIColor(red: 0.075, green: 0.494, blue: 0.518, alpha: 1)
        }
    }
    
    func iconTintColor() -> UIColor {
        switch self {
        case .disabled: return UIColor(red: 0.800, green: 0.800, blue: 0.800, alpha: 1)
        default: return UIColor(red: 0.075, green: 0.494, blue: 0.518, alpha: 1)
        }
    }
    
    func borderWidth() -> CGFloat {
        switch self {
        case .active: return 1.0
        default: return 0
        }
    }
    
    func setElevation(_ view: UIView) {
        switch self {
        default:
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.shadowRadius = 0
            view.layer.shadowOpacity = 0
            view.layer.shadowColor = UIColor.black.cgColor
        }
    }
}
