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
    private let dependencies: ProfileDependency
    private var reloadButton = UIBarButtonItem()
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
    
    private lazy var chartView: ChartsInfoView = {
        return ChartsInfoView()
    }()
    
    init(dependencies: ProfileDependency) {
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

private extension ProfileViewController {
    func setAppearance() {
        configView()
        addViewToScrollableStackView()
    }
    
    func configView() {
        configureNavigationBar()
        view.backgroundColor = .white
        showSpinner()
    }
    
    func bind() {
        bindViewModel()
        bindHeaderView()
        bindChartView()
    }
    
    func bindViewModel() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .idle:
                break
            case .showChartView(let infoChartView):
                guard let self else { return }
                self.chartView.isHidden = infoChartView?.count == 0 ? true : false
                self.chartView.configureViewWith(DefaultChartViewData(charts: infoChartView ?? [], chartSelectedIndex: 0))
            case .showErrorPlayerDetails:
                self?.presentAlert(message: "Error al cagar los datos de los modos de juego", title: "Error")
            case .hideLoading:
                self?.hideSpinner()
            }
        }.store(in: &cancellable)
    }
    
    func bindChartView() {
        chartView.publisher.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .didSelectChart(let chart):
                break
                //TODO: guardar para controlar el chart selecionado
            case .didTapAverageTooltip:
                break
                //TODO: presentar el bottomSheet
            }
        }.store(in: &cancellable)
    }
    
    func  bindHeaderView() {
        headerView.publisher.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .didSelectButton(let type):
                break
                //TODO: navegar hacia la vista indicada con un switch del type
            case .didTapHelpTooltip:
                break
                //TODO: presentar el bottomSheet
            }
        }.store(in: &cancellable)
    }
    
    func configureNavigationBar() {
        navigationItem.title = "profileViewControllerNavigationItem".localize()
        let helpReloadButton = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(helpReloadButtonAction))
        reloadButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise.circle.fill"), style: .plain, target: self, action: #selector(reloadButtonAction))
        self.navigationItem.setRightBarButtonItems([reloadButton, helpReloadButton], animated: true)
    }
    
    func addViewToScrollableStackView() {
        scrollableStackView.addArrangedSubview(headerView)
        //TODO: graphView
        //TODO: totalizatorView
        //TODO: title chart and image with gesture
        scrollableStackView.addArrangedSubview(chartView)
        //TODO: matchesView
    }
    
    @objc private func helpReloadButtonAction() {
        print("mostrar info del reload en un botomsheet")
    }
    
    @objc private func reloadButtonAction() {
        UserDefaults.standard.set(Date(), forKey: "date")
         guard UserDefaults.standard.bool(forKey: "refreshCount") == true else {
             reloadButton.isEnabled = false
             DispatchQueue.main.asyncAfter(deadline: .now() + 120) { [weak self] in
                 self?.reloadButton.isEnabled = true
                 UserDefaults.standard.set(false, forKey: "refreshCount")
             }
             viewModel.reload()
             return
         }
    }
}

extension ProfileViewController: MessageDisplayable { }
extension ProfileViewController: SpinnerDisplayable { }
