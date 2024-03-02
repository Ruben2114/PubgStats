//
//  AttributesDetailViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit
import Combine

class AttributesDetailViewController: UIViewController {
    enum Constant {
        static let spacing: CGFloat = 16
    }
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: AttributesDetailViewModel
    private let dependencies: AttributesDetailDependencies
    private var listAttributes: AttributesViewRepresentable?
    private let identifier = "AttributesDetailsCollectionViewCell"
    private lazy var imageBackground: UIImageView = {
        UIImageView()
    }()
    private lazy var scrollableStackView: ScrollableStackView = {
        let view = ScrollableStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setup(with: self.view)
        view.setSpacing(16)
        return view
    }()
    private lazy var subcategoriesCollection: UICollectionView = {
        let collect = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collect.backgroundColor = .clear
        collect.translatesAutoresizingMaskIntoConstraints = false
        return collect
    }()
    private var collectionViewHeight: NSLayoutConstraint?
    private lazy var detailsCardView: DetailsCardView = {
        DetailsCardView()
    }()
    
    init(dependencies: AttributesDetailDependencies) {
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
        setAppearance()
        bind()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

private extension AttributesDetailViewController {
    func setAppearance() {
        configureScrollableStackView()
        expandCollapseSubcategoriesAppearence()
        registerCell()
    }
    
    func configureScrollableStackView() {
        let cardView = detailsCardView.embedIntoView(topMargin: Constant.spacing, leftMargin: Constant.spacing, rightMargin: Constant.spacing)
        scrollableStackView.addArrangedSubview(cardView)
        let newCollection = subcategoriesCollection.embedIntoView(leftMargin: Constant.spacing, rightMargin: Constant.spacing)
        scrollableStackView.addArrangedSubview(newCollection)
    }
    
    func configureNavigationBar() {
        titleNavigation(viewModel.model?.title.capitalized, backButton: #selector(backButtonAction))
        let image = viewModel.model?.type.getImage() ?? ""
        imageBackground.image = UIImage(named: image)
        view.insertSubview(imageBackground, at: 0)
        imageBackground.frame = view.bounds
    }
    
    func bind() {
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .idle:
                    break
                case .showWeaponOrGamesModes(let attributes):
                    self?.listAttributes = attributes
                    self?.detailsCardView.configureDetailsView(attributes)
                case .showSurvival(let attributeHome, let attributeDetails):
                    self?.listAttributes = attributeDetails
                    self?.detailsCardView.configureHomeView(attributeHome)
                }
                self?.subcategoriesCollection.reloadData()
                self?.getMaxHeight()
            }.store(in: &cancellable)
    }
    
    func expandCollapseSubcategoriesAppearence() {
        collectionViewHeight = subcategoriesCollection.heightAnchor.constraint(equalToConstant: 2000)
        collectionViewHeight?.isActive = true
        subcategoriesCollection.isScrollEnabled = false
        subcategoriesCollection.dataSource = self
        subcategoriesCollection.delegate = self
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: identifier, bundle: nil)
        subcategoriesCollection.register(cellNib, forCellWithReuseIdentifier: identifier)
        subcategoriesCollection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    func getMaxHeight() {
        subcategoriesCollection.layoutIfNeeded()
        var cellHeigth: CGFloat = 0
        var headerHeigth: CGFloat = 0
        var countCell: CGFloat = 0
        subcategoriesCollection.subviews.forEach { subview in
            if let cell = subview as? AttributesDetailsCollectionViewCell {
                cellHeigth += (cell.frame.height)
                countCell += 1
            } else if let header = subview as? UICollectionReusableView {
                headerHeigth += header.frame.height
            }
        }
        var maxHeigth: CGFloat = (cellHeigth / 2) + CGFloat((countCell * (Constant.spacing / 2))) + headerHeigth
        listAttributes?.attributesDetails.forEach({ attributes in
            if attributes.count % 2 != 0 {
                maxHeigth += (cellHeigth / countCell) - Constant.spacing
            }
        })
        collectionViewHeight?.constant = maxHeigth
    }
    
    @objc func backButtonAction() {
        viewModel.backButton()
    }
}

extension AttributesDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listAttributes?.attributesDetails[section].count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? AttributesDetailsCollectionViewCell else { return UICollectionViewCell() }
        let list = listAttributes?.attributesDetails[indexPath.section].sorted { $0.title < $1.title}
        cell.configureWith(list?[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (self.view.frame.width - (Constant.spacing * 3)) / 2.0
        return CGSize(width: width, height: width / 2)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listAttributes?.attributesDetails.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        let label = UILabel(frame: headerView.bounds)
        label.text = listAttributes?.attributesDetails[indexPath.section].first?.titleSection?.uppercased()
        label.textAlignment = .center
        label.textColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1)
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 20)
        headerView.addSubview(label)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constant.spacing, left: 0, bottom: Constant.spacing, right: 0)
    }
}
