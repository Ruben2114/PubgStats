//
//  BottomSheetView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 15/1/24.
//

import UIKit

public final class BottomSheetView {
    
    private lazy var stackViewBottomSheet: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter", size: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    public func show(in viewController: UIViewController,
                     title: String,
                     subtitle: String) {
        let bottomSheetViewController = BottomSheetViewController()
        let customView = createView(title: title, subtitle: subtitle)
        let controllerDetent = UISheetPresentationController.Detent.custom { [weak self] context in
            self?.customHeight(of: customView, in: viewController)
        }
        bottomSheetViewController.sheetPresentationController?.detents = [controllerDetent]
        bottomSheetViewController.sheetPresentationController?.selectedDetentIdentifier = .medium
        bottomSheetViewController.sheetPresentationController?.prefersGrabberVisible = true
        bottomSheetViewController.sheetPresentationController?.preferredCornerRadius = 20
        bottomSheetViewController.setBottomSheet(view: customView)
        viewController.present(bottomSheetViewController, animated: true)
    }
    
    private func customHeight(of view: UIView, in container: UIViewController) -> CGFloat {
        let targetSize = CGSize(width: container.view.bounds.width, height: UIView.layoutFittingExpandedSize.height)
        let viewSize = view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: UILayoutPriority.required,
            verticalFittingPriority: UILayoutPriority.fittingSizeLevel
        )
        return viewSize.height + 60
    }
    
    private func createView(title: String, subtitle: String) -> UIView {
        titleLabel.text = title
        stackViewBottomSheet.addArrangedSubview(titleLabel)
        subtitleLabel.text = subtitle
        stackViewBottomSheet.addArrangedSubview(subtitleLabel)
        return stackViewBottomSheet
    }
}
