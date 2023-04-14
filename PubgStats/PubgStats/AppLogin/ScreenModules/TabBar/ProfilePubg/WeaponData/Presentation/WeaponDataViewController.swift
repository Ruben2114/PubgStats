//
//  WeaponDataViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import UIKit
import Combine

class WeaponDataViewController: UIViewController {
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
    private let sessionUser: ProfileEntity
    var cancellable = Set<AnyCancellable>()
    private let viewModel: WeaponDataViewModel
    private let dependencies: WeaponDataDependency
    init(dependencies: WeaponDataDependency) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        self.sessionUser = dependencies.external.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configUI()
        configConstraint()
    }
    private func configUI(){
        title = "Tipos de armas"
        backButton(action: #selector(backButtonAction))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ItemDataCollectionViewCell.self, forCellWithReuseIdentifier: "ItemDataCollectionViewCell")
    }
    
    private func bind() {
         viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
             switch state {
             case .fail(_):
                 self?.presentAlert(message: "Error al cargar los datos: por favor vuelva e intentarlo en unos segundos", title: "Error")
             case .success:
                 self?.hideSpinner()
                 self?.collectionView.reloadData()
             case .loading:
                 self?.showSpinner()
             }
         }.store(in: &cancellable)
        viewModel.viewDidLoad()
     }
   
    private func configConstraint(){
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

extension WeaponDataViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.weaponType.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemDataCollectionViewCell", for: indexPath) as! ItemDataCollectionViewCell
        cell.backgroundColor = .systemCyan
        cell.layer.cornerRadius = 15
        let model = viewModel.weaponType[indexPath.row]
        cell.categoryMenuImageView.image = UIImage(named: model)
        cell.titleCategoryLabel.text = model
        return cell
    }
}
extension WeaponDataViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let weapon = getItem(row: row)
        viewModel.goWeaponItem(weapon: weapon)
    }
    func getItem(row: Int) -> String {
        let weapon = viewModel.weaponType[row]
        return weapon
    }
}
extension WeaponDataViewController: SpinnerDisplayable { }
extension WeaponDataViewController: MessageDisplayable { }
