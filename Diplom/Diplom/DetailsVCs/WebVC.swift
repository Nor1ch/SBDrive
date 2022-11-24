//
//  WebVC.swift
//  Diplom
//
//  Created by Nor1 on 27.08.2022.
//

import Foundation
import WebKit

class WebVC : UIViewController, WKNavigationDelegate {
    private var viewModel: FilesViewModel
    private var path: String
    private var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.allowsLinkPreview = false
        webView.navigationDelegate = self
        view = webView
    }
    init(viewModel: FilesViewModel, name: String, path: String) {
        self.viewModel = viewModel
        self.path = path
        super.init(nibName: nil, bundle: nil)
        self.title = name
    }
    
    private lazy var doneButton : UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(named: "complite"), style: .plain, target: self, action: #selector(doDismiss))
        view.tintColor = Constants.Colors.mainBlue
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = doneButton
        makeView()
    }
    
    private func makeView(){
        guard let url = URL(string: self.path) else {return}
        webView.load(URLRequest(url: url))
    }
    @objc private func doDismiss(){
        navigationController?.popToRootViewController(animated: true)
    }
}
