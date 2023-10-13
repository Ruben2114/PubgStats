//
//  ScrollableStackView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/10/23.
//

import UIKit

public class ScrollableStackView: UIView {
    public lazy var scrollView = UIScrollView()
    weak var view: UIView?
    
    public lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setup(with view: UIView) {
        self.view = view
        self.view?.addSubview(scrollView)
        self.setupScrollView()
        self.setupStackView()
        //self.backgroundColor = UIColor.white
    }
    
    public func setScrollInsect(_ insect: UIEdgeInsets) {
        self.scrollView.contentInset = insect
    }
    
    public func addArrangedSubview(_ view: UIView) {
        self.stackView.addArrangedSubview(view)
    }
    
    public func setSpacing(_ spacing: CGFloat) {
        self.stackView.spacing = spacing
    }
}

private extension ScrollableStackView {
    private func setupScrollView() {
        self.scrollView.backgroundColor = .clear
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addScrollConstraint()
    }
    
    private func addScrollConstraint() {
        guard let view = self.view else { return }
        self.scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    private func setupStackView() {
        guard let view = self.view else { return }
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(stackView)
        self.stackView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}
