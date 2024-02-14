//
//  AttributesDetailViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit
import Combine

class AttributesDetailViewController: UIViewController {
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
}

private extension AttributesDetailViewController {
    func setAppearance() {
        configureScrollableStackView()
        expandCollapseSubcategoriesAppearence()
        registerCell()
        configureNavigationBar()
    }
    
    func configureScrollableStackView() {
        scrollableStackView.addArrangedSubview(detailsCardView)
        let newCollection = subcategoriesCollection.embedIntoView(leftMargin: 16, rightMargin: 16)
        scrollableStackView.addArrangedSubview(newCollection)
    }
    
    func configureNavigationBar() {
        backButton(action: #selector(backButtonAction))
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor : UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1),
            .font : UIFont(name: "AmericanTypewriter-Bold", size: 20) ?? UIFont.systemFont(ofSize: 16)
        ]
    }
    
    func bind() {
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] attributes in
                self?.listAttributes = attributes
                self?.detailsCardView.configureDetailsView(attributes) //TODO: si son weapon pues otra
                self?.configureUI()
                self?.subcategoriesCollection.reloadData()
                self?.getMaxHeight()
            }.store(in: &cancellable)
    }
    
    func configureUI() {
        let image = listAttributes?.type.getImage() ?? ""
        imageBackground.image = UIImage(named: image)
        view.insertSubview(imageBackground, at: 0)
        imageBackground.frame = view.bounds
        title = listAttributes?.title.capitalized
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
            } else {
                headerHeigth += subview.frame.height
            }
        }
        var maxHeigth: CGFloat = (cellHeigth / 2) + CGFloat((countCell * 8)) + headerHeigth
        if cellHeigth.remainder(dividingBy: 2) != 0 {
            maxHeigth += (cellHeigth / countCell) * 2
        }
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
        cell.configureWith(listAttributes?.attributesDetails[indexPath.section][indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (self.view.frame.width - 16 - 32) / 2.0
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
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
}
