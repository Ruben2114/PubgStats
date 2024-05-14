//
//  ProfilePubgViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//

import UIKit
import Combine

final class ProfileViewController: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: ProfileViewModel
    private lazy var reloadButton = createButtonImage(image: UIImage(systemName: "arrow.clockwise.circle.fill"), selector: #selector(reloadButtonAction))
    private lazy var infoButton = createButtonImage(image: UIImage(systemName: "questionmark.circle"), selector: #selector(helpReloadButtonAction))
    private lazy var scrollableStackView: ScrollableStackView = {
        let view = ScrollableStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setup(with: self.view)
        view.setScrollInsect(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        return view
    }()
    private lazy var headerView: ProfileHeaderView = {
        return ProfileHeaderView()
    }()
    private lazy var dataGeneralView: ProfileGeneralView = {
        ProfileGeneralView()
    }()
    private lazy var chartView: ChartsInfoView = {
        return ChartsInfoView()
    }()
    private lazy var bottomSheetView: BottomSheetView = {
        BottomSheetView()
    }()
    private lazy var newsCardView: VersatileCardView = {
        VersatileCardView()
    }()
    private lazy var survivalCardView: VersatileCardView = {
        VersatileCardView()
    }()
    private lazy var matchesCardView: VersatileCardView = {
        VersatileCardView()
    }()
        
    init(dependencies: ProfileDependencies) {
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
        if viewModel.type == .favourite { showLoading() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

private extension ProfileViewController {
    func setAppearance() {
        configureImageBackground("backgroundProfile")
        addViewToScrollableStackView()
    }
    
    func bind() {
        bindViewModel()
        bindHeaderView()
        bindChartView()
        bindVersatileCard()
        bindGeneralView()
    }
    
    func bindViewModel() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .idle:
                break
            case .showChartView(let infoChartView):
                self?.chartView.isHidden = infoChartView?.count == 0 ? true : false
                self?.chartView.configureViewWith(DefaultChartViewData(charts: infoChartView ?? [], chartSelectedIndex: 0))
            case .showErrorPlayerDetails:
                self?.scrollableStackView.stackView.isHidden = true
                self?.presentAlert(message: "errorPlayerDetails".localize(),
                                   title: "Error",
                                   action: [.cancel { [weak self] in self?.viewModel.backButton() },
                                            .retry { [weak self] in self?.viewModel.reload() }
                                   ])
            case .showHeader(let data):
                self?.headerView.configureView(representable: data)
            case .showDataGeneral(let data):
                self?.dataGeneralView.configureView(data)
            case .hideLoading:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [ weak self] in
                    self?.hideLoading()
                }
            case .infoVersatileCard(let versatileCardTypes, let matches):
                self?.configureVersatilCard(versatileCardTypes, matches)
            }
        }.store(in: &cancellable)
    }
    
    func bindChartView() {
        chartView.publisher.receive(on: DispatchQueue.main).sink { [weak self] data in
            self?.configureBottomSheet(title: data.0, subtitle: data.1)
        }.store(in: &cancellable)
    }
    
    func bindHeaderView() {
        headerView.publisher.receive(on: DispatchQueue.main).sink { [weak self] type in
            switch type {
            case .modes:
                self?.viewModel.goToModes()
            case .weapon:
                self?.viewModel.goToWeapon()
            }
        }.store(in: &cancellable)
    }
    
    func bindGeneralView() {
        dataGeneralView.publisher.receive(on: DispatchQueue.main).sink { [weak self] state in
            self?.configureBottomSheet(title: state.0, subtitle: state.1)
        }.store(in: &cancellable)
    }
    
    func bindVersatileCard() {
        newsCardView.publisher.sink { [weak self] in
            self?.viewModel.goToWeb(urlString: .news)
        }.store(in: &cancellable)
        
        survivalCardView.publisher.sink { [weak self] in
            self?.viewModel.goToSurvival()
        }.store(in: &cancellable)
        
        matchesCardView.publisher.sink { [weak self] in
            self?.viewModel.goToMatches()
        }.store(in: &cancellable)
    }
    
    func configureNavigationBar() {
        titleNavigation("profileViewControllerNavigationItem",
                        backButton: viewModel.type == .favourite ? #selector(backButtonAction) : nil, 
                        moreButton: [reloadButton, infoButton])
    }
    
    func addViewToScrollableStackView() {
        scrollableStackView.addArrangedSubview(headerView)
        scrollableStackView.addArrangedSubview(dataGeneralView)
        scrollableStackView.addArrangedSubview(matchesCardView)
        scrollableStackView.addArrangedSubview(survivalCardView)
        scrollableStackView.addArrangedSubview(chartView)
        scrollableStackView.addArrangedSubview(newsCardView)
    }
    
    func configureBottomSheet(title: String, subtitle: String) {
        bottomSheetView.show(in: self, title: title, subtitle: subtitle)
    }
    
    func configureVersatilCard(_ types: [ProfileVersatileCardType], _ matches: Int) {
        types.forEach { type in
            let data = type.getData(matchesCount: matches)
            switch type {
            case .matches:
                matchesCardView.setupVersatileCard(data)
            case .survival:
                survivalCardView.setupVersatileCard(data)
            case .news:
                newsCardView.setupVersatileCard(data)
            }
        }
        if !types.contains(.news) {
            newsCardView.isHidden = true
        }
    }
    
    @objc private func helpReloadButtonAction() {
        configureBottomSheet(title: "profileHelpReloadTitle".localize(),
                             subtitle: "profileHelpReloadSubtitle".localize())
    }
    
    @objc private func reloadButtonAction() {
        UserDefaults.standard.set(Date(), forKey: "date")
        reloadButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 120) { [weak self] in
            self?.reloadButton.isEnabled = true
        }
        showLoading()
        viewModel.reload()
    }
    
    @objc func backButtonAction() {
        viewModel.backButton()
    }
}

extension ProfileViewController: MessageDisplayable { }
extension ProfileViewController: LoadingPresentationDisplayable { }
