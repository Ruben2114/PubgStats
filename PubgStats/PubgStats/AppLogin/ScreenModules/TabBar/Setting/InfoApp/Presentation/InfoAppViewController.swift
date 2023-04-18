//
//  InfoAppViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/4/23.
//

import UIKit

class InfoAppViewController: UIViewController {
    private lazy var infoLabel = makeLabel(title: viewModel.info, color: .black, font: 20, style: .body)
    private let viewModel: InfoAppViewModel
    var contentView = UIView()
    var mainScrollView = UIScrollView()
    var label: UILabel!
    
    init(dependencies: InfoAppDependency) {
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configScroll()
        configUI()
        configConstraints()
    }
    private func configUI() {
        view.backgroundColor = .systemBackground
        title = "Aviso Legal"
        backButton(action: #selector(backButtonAction))
    }
    private func configConstraints() {
         infoLabel.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 0)
         infoLabel.sizeToFit()
         contentView.addSubview(infoLabel)
         mainScrollView.contentSize = infoLabel.bounds.size
    }
    @objc func backButtonAction() {
        viewModel.backButton()
    }
}
extension InfoAppViewController: ViewScrollable{}
