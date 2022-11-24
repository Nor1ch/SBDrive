//
//  LoginVC.swift
//  Diplom
//
//  Created by Nor1 on 16.11.2022.
//

import Foundation
import UIKit
import SnapKit


class LoginVC : UIViewController {
    private let viewModel: LoginViewModel
    private let titleVC: String = "Авторизация"
    private let appID: String = "b996b9002c9d463b85daac04298e2f1b"
    
    init(viewModel: LoginViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var lostConnectionView : UILabel = {
       let view = UILabel()
        view.text = Constants.Text.Connection.title
        view.font = Constants.Fonts.smallBody13
        view.backgroundColor = .red
        view.textAlignment = .center
        view.textColor = Constants.Colors.mainWhite
        view.alpha = {
            if NetworkMonitor.shared.isConnected {
                return 0
            } else {
                return 1
            }
        }()
        return view
    }()
    
    private lazy var imageViewLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "loadscreen")
        return view
    }()
    
    private lazy var loginButton: UIButton = {
        let view = UIButton()
        let buttonTitle = Constants.Text.Login.buttonLogin
        var config = UIButton.Configuration.filled()
        let attr : [NSAttributedString.Key: Any] = [
            .font : Constants.Fonts.button16 as Any,
            .foregroundColor : Constants.Colors.mainWhite as Any
        ]
        config.titleAlignment = .center
        config.baseBackgroundColor = Constants.Colors.mainBlue
        config.baseForegroundColor = Constants.Colors.mainBlack
        config.attributedTitle = AttributedString(buttonTitle, attributes: AttributeContainer(attr))
        config.cornerStyle = .medium
        view.configuration = config
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doLogin)))
        return view
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(statusObs(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
        setupViews()
        makeConstraints()
    }
    
    private func setupViews(){
        view.addSubview(imageViewLogo)
        view.addSubview(loginButton)
        view.addSubview(indicator)
        view.addSubview(lostConnectionView)
    }
    
    private func makeConstraints(){
        
        lostConnectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        imageViewLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(183)
            make.height.equalTo(220)
            make.width.equalTo(245)
        }
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(80)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(320)
        }
        indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(loginButton.snp.top).inset(50)
            make.width.equalTo(160)
            make.height.equalTo(50)
        }
    }
    
    @objc private func doLogin(){
        loginButton.isHidden = true
        indicator.startAnimating()
        switch NetworkMonitor.shared.isConnected{
        case true:
            viewModel.openWVLogin(title: titleVC, path: "https://oauth.yandex.ru/authorize?response_type=token&client_id=b996b9002c9d463b85daac04298e2f1b")
        case false:
            viewModel.makeTabBar()
        }
    }
    
    @objc private func statusObs(notification: Notification){
        if NetworkMonitor.shared.isConnected {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5){
                    self.lostConnectionView.alpha = 1
                }
            }
        } else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5){
                    self.lostConnectionView.alpha = 0
                }
            }
        }
    }
}
