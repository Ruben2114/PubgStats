//
//  GamesModesDataViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit

class GamesModesDataViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let layoutWidth = (ViewValues.widthScreen - ViewValues.doublePadding) / ViewValues.multiplierTwo
        let layoutHeigth = (ViewValues.widthScreen - ViewValues.doublePadding) / ViewValues.multiplierTwo
        layout.itemSize = CGSize(width: layoutWidth, height: layoutHeigth)
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        layout.sectionInset = UIEdgeInsets(top: .zero, left: ViewValues.normalPadding, bottom: .zero, right: ViewValues.normalPadding)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private let viewModel: GamesModesDataViewModel
    private let dependencies: GamesModesDataDependency
    init(dependencies: GamesModesDataDependency) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configConstraint()
        bind()
    }
    func bind() {
        viewModel.fetchDataGamesModes()
        collectionView.reloadData()
    }
    func configUI(){
        title = "Modos de juego"
        view.backgroundColor = .systemGroupedBackground
        backButton(action: #selector(backButtonAction))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ItemDataCollectionViewCell.self, forCellWithReuseIdentifier: "ItemDataCollectionViewCell")
    }
    func configConstraint(){
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    @objc func backButtonAction() {
        viewModel.backButton()
    }
}
extension GamesModesDataViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.nameGamesModes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemDataCollectionViewCell", for: indexPath) as! ItemDataCollectionViewCell
        cell.backgroundColor = .systemCyan
        cell.layer.cornerRadius = 15
        let model = viewModel.nameGamesModes[indexPath.row]
        cell.categoryMenuImageView.image = UIImage(named: model)
        cell.titleCategoryLabel.text = model
        return cell
    }
}
extension GamesModesDataViewController: UICollectionViewDelegate {
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

