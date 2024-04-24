//
//  InfoAppViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/4/23.
//

import UIKit

class InfoAppViewController: UIViewController {
    private lazy var infoLabel = makeLabel(title: viewModel.info, color: .black, font: 17, style: .body)
    private let viewModel: InfoAppViewModel
    var contentView = UIView()
    var mainScrollView = UIScrollView()
    
    init(dependencies: InfoAppDependency) {
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    private func configUI() {
        view.backgroundColor = .systemBackground
        titleNavigation("infoAppViewTitle", backButton: #selector(backButtonAction))
        configScroll()
        configConstraints()
    }
    private func configConstraints() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        infoLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }
    @objc private func backButtonAction() {
        viewModel.backButton()
    }
}
extension InfoAppViewController: ViewScrollable{}
