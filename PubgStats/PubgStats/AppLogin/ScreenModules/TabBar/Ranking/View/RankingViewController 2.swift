//
//  RankingViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

class RankingViewController: UIViewController {
    private let dependencies: RankingDependency
   
    init(dependencies: RankingDependency) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    private func configUI() {
        view.backgroundColor = .systemBackground
    }
}
