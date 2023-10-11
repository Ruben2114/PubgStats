//
//  GamesModesDataViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit

class GamesModesDataViewController: UIViewController {
    private lazy var collectionView = makeCollectionView2()
    private let viewModel: GamesModesDataViewModel
    private let dependencies: GamesModesDataDependency
    
    init(dependencies: GamesModesDataDependency) {
        self.dependencies = dependencies
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
        bind()
    }
    private func bind() {
        viewModel.fetchDataGamesModes()
        collectionView.reloadData()
    }
    private func configUI(){
        title = "gamesModesDataViewControllerTitle".localize()
        view.backgroundColor = .systemGroupedBackground
        backButton(action: #selector(backButtonAction))
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CustomCell")
        configConstraint()
    }
    private func configConstraint(){
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    @objc private func backButtonAction() {
        viewModel.backButton()
    }
}

extension GamesModesDataViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.nameGamesModes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! ItemCollectionViewCell
 
        cell.backgroundColor = .systemGray
        cell.layer.cornerRadius = 15
        let model = viewModel.nameGamesModes[indexPath.row]
        cell.imageView.image = UIImage(named: model)
        cell.titleLabel.text = model
        cell.levelLabel.text = "20"
        cell.spLabel.text = "SP: 300"
        cell.rankLabel.text = "no tienes rank en esta sesion"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let gameMode = getItem(row: row)
        viewModel.goGameMode(gameMode: gameMode)
    }
    func getItem(row: Int) -> String {
        let gameMode = viewModel.nameGamesModes[row]
        return gameMode
    }
}


