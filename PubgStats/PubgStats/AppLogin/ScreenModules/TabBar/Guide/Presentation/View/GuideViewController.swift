//
//  GuideViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//

import UIKit
import WebKit
import Combine

class GuideViewController: UIViewController  {
    private let webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let web = WKWebView(frame: .zero, configuration: webConfiguration)
        web.translatesAutoresizingMaskIntoConstraints = false
        web.scrollView.contentInsetAdjustmentBehavior = .never
        return web
    }()
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: GuideViewModel
    
    init(dependencies: GuideDependency) {
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
    private func configUI() {
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        configConstraints()
    }
    private func configConstraints() {
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    private func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state{
            case .success(let modelo):
                self?.hideSpinner()
                self?.webView.load(modelo)
            case .loading:
                self?.showSpinner()
            case .fail(error: let error):
                self?.hideSpinner()
                self?.presentAlert(message: error, title: "Error")
            }
        }.store(in: &cancellable)
        viewModel.checkUrl()
    }
}
extension GuideViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
}
extension GuideViewController: SpinnerDisplayable {}
extension GuideViewController: MessageDisplayable { }
