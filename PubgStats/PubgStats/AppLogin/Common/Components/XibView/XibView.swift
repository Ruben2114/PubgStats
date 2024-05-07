//
//  XibView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 16/10/23.
//

import Foundation
import UIKit

open class XibView: UIView {
    public var view: UIView?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.xibSetup()
    }
    
    private func xibSetup() {
        self.view = self.loadViewFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let newView = self.view else { return }
        self.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newView.leftAnchor.constraint(equalTo: self.leftAnchor),
            newView.rightAnchor.constraint(equalTo: self.rightAnchor),
            newView.topAnchor.constraint(equalTo: self.topAnchor),
            newView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: .main)
        return nib.instantiate(withOwner: self, options: nil)[0] as? UIView
    }
}
