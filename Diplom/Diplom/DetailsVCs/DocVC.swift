//
//  DocVC.swift
//  Diplom
//
//  Created by Nor1 on 22.07.2022.
//

import Foundation
import UIKit
import PDFKit
import SnapKit
import WebKit

class DocVC : UIViewController, WKNavigationDelegate{
    private var viewModel : FilesViewModel
    private var path:  String
    private var file: String
    private var name: String
    
    private lazy var pdfView : PDFView = {
        let view = PDFView()
        return view
    }()
  
    private lazy var indicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()
    
    private lazy var webView : WKWebView = {
        let view = WKWebView()
        return view
    }()
    
    private lazy var viewContainer : UIView = {
       let view = UIView()
        view.addSubview(pdfView)
        view.addSubview(webView)
        return view
    }()
    
    init(viewModel: FilesViewModel, path: String, file: String, title: String) {
        self.viewModel = viewModel
        self.path = path
        self.file = file
        self.name = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var pencilButton : UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(named: "pencil"), style: .plain, target: self, action: #selector(editPressed))
        view.isEnabled = true
        return view
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let attrNavigationBar = [
                    NSAttributedString.Key.font: Constants.Fonts.headerFont17 as Any,
                    NSAttributedString.Key.foregroundColor: Constants.Colors.mainBlack as Any
                ]
        navigationController?.navigationBar.titleTextAttributes = attrNavigationBar
        
        if FilesViewModel.isChanged == true {
            title = FilesViewModel.changedName
        }
        if FilesViewModel.isDeleted == true {
            navigationController?.popViewController(animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        makeConstraints()
        makePDFDocument()
        title = name
        navigationItem.rightBarButtonItem = pencilButton
        navigationItem.rightBarButtonItem?.tintColor = Constants.Colors.mainGrey
        tabBarController?.tabBar.isHidden = true
    
    }
 
    private func setupViews(){
        view.addSubview(viewContainer)
        view.addSubview(indicator)
        indicator.startAnimating()
        view.backgroundColor = .white
    }
    
    private func makeConstraints(){
        pdfView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            self.pdfView.isHidden = true
        }
        indicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            self.webView.isHidden = true
        }
        viewContainer.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    private func makePDFDocument(){
        DispatchQueue.global().async {
            guard let url = URL(string: self.file) else {return}
            if let document = PDFDocument(url: url){
                DispatchQueue.main.async {
                self.webView.removeFromSuperview()
                self.pdfView.document = document
                self.pdfView.isHidden = false
                self.indicator.stopAnimating()
                
                }
            } else {
                DispatchQueue.main.async {
                    self.pdfView.removeFromSuperview()
                    self.indicator.stopAnimating()
                    self.webView.load(URLRequest(url: url))
                    self.webView.isHidden = false
                }
            }
        }
    }
    @objc private func editPressed(){
        viewModel.openEdit(title: name, path: path, file: file, image: UIImage(named: "pencil") ?? UIImage())
        FilesViewModel.docVC = true
    }
}
