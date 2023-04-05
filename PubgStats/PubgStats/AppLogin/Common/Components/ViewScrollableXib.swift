//
//  ViewScrollableXib.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

import UIKit

protocol ViewScrollableXib: AnyObject {
    var mainScrollView: UIScrollView { get set }
}

extension ViewScrollableXib where Self: UIViewController {
    func configScroll(selector: Selector) {
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        configConstraints()
        mainScrollView.refreshControl = UIRefreshControl()
        mainScrollView.refreshControl?.addTarget(self, action: selector, for: .valueChanged)

    }
    
    private func configConstraints() {
        view.addSubview(mainScrollView)
        mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -600).isActive = true
        view.heightAnchor.constraint(greaterThanOrEqualTo: mainScrollView.heightAnchor).isActive = true
        mainScrollView.isScrollEnabled = true
    }
}

