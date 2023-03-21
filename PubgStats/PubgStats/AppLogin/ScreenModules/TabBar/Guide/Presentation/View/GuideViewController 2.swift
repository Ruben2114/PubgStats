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
    var cancel = Set<AnyCancellable>()
    private let viewModel: GuideViewModel
    var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let web = WKWebView(frame: .zero, configuration: webConfiguration)
        return web
    }()
    
    init(viewModel: GuideViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Guide"
        webView.navigationDelegate = self
        bind()
        view = webView
    }
    
     func bind() {
         viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
             switch state{
             case .success(let modelo):
                 self?.hideSpinner()
                 self?.webView.load(modelo)
             case .loading:
                 self?.showSpinner()
             case .fail(error: let error):
                 self?.presentAlert(message: error, title: "Error")
             }
         }.store(in: &cancel)
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