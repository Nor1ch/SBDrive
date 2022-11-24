//
//  WVLogin.swift
//  Diplom
//
//  Created by Nor1 on 18.11.2022.
//

import Foundation
import WebKit


class WVLogin : UIViewController, WKNavigationDelegate {
    private let path: String
    private let titleVC: String
    private let viewModel: WVLoginViewModel
    private var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.allowsLinkPreview = false
        webView.navigationDelegate = self
        view = webView
    }
    init(viewModel: WVLoginViewModel, title: String, path: String) {
        self.viewModel = viewModel
        self.titleVC = title
        self.path = path
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleVC
        makeView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func makeView(){
        guard let url = URL(string: self.path) else {return}
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            let token = components.queryItems?.first(where: {$0.name == "access_token"})?.value
            if let token = token {
                webView.stopLoading()
                UserDefaultsToken.saveToken(token: token)
                viewModel.openTabBar()
            }
        }
        decisionHandler(.allow)
    }
}
