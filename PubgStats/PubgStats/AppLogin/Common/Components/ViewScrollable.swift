//
//  ViewScrollable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

import UIKit

protocol ViewScrollable: AnyObject {
    var mainScrollView: UIScrollView { get set }
    var contentView: UIView { get set }
}

extension ViewScrollable where Self : UIViewController {
    func configScroll() {
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        configConstraints()
    }
    
    private func configConstraints() {
        view.addSubview(mainScrollView)
        mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mainScrollView.contentSize = view.bounds.size
        
        mainScrollView.addSubview(contentView)
        contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: mainScrollView.centerYAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor).isActive = true
    }
}
