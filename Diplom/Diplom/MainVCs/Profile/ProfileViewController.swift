//
//  ProfileViewController.swift
//  Diplom
//
//  Created by Nor1 on 05.07.2022.
//

import UIKit
import SnapKit

class ProfileViewController : UIViewController {
    
    private var viewModel: ProfileViewModel
    let shapeLayer = CAShapeLayer()
    let shadowLayer = CAShapeLayer()
    var strokeEndValue = 0.0
    

    private lazy var circleView : UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var imageUsed : UIImageView = {
       let view = UIImageView()
        let image = UIImage(systemName: "circle.fill")
        view.tintColor = Constants.Colors.mainPink
        view.image = image
        return view
    }()
    private lazy var imageFree : UIImageView = {
       let view = UIImageView()
        let image = UIImage(systemName: "circle.fill")
        view.tintColor = Constants.Colors.mainGrey
        view.image = image
        return view
    }()
    
    private lazy var labelUsed : UILabel = {
       let view = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        view.text = "0" + Constants.Text.Profile.usedSize
        view.font = Constants.Fonts.mainBody15
        return view
    }()
    private lazy var labelFree : UILabel = {
       let view = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        view.text = "0" + Constants.Text.Profile.freeSize
        view.font = Constants.Fonts.mainBody15
        return view
    }()
    private lazy var labelTotal : UILabel = {
       let view = UILabel()
        view.text = "0" + Constants.Text.Profile.totalSize
        view.font = Constants.Fonts.headerFont17
        return view
    }()
    
    private lazy var buttonPublished : UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        let title = Constants.Text.Profile.published
        let attr : [NSAttributedString.Key: Any] = [
            .font : Constants.Fonts.button16 as Any,
            .foregroundColor : Constants.Colors.mainBlack as Any
        ]
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer(attr))
        config.titleAlignment = .leading
        config.baseBackgroundColor = UIColor.white
        config.image = UIImage(named: "Vector")
        config.imagePlacement = .trailing
        config.imagePadding = 110
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 4)
        config.cornerStyle = .medium
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 120)
        view.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.08)
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.4)
        view.layer.shadowOpacity = 1
        
        view.configuration = config
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped)))
        return view
    }()
    
    
    private lazy var viewInfo : UIView = {
        let view = UIView()
        view.addSubview(imageUsed)
        view.addSubview(imageFree)
        view.addSubview(labelUsed)
        view.addSubview(labelFree)
        view.addSubview(buttonPublished)
        return view
    }()
    
    private lazy var popLogoutAlertController: UIAlertController = {
        let view = UIAlertController(title: Constants.Text.Sheet.exit, message: Constants.Text.Sheet.agree, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: Constants.Text.Sheet.yes, style: .default){_ in
            let user = UserToken(access_token: UserDefaultsToken.loadToken() ?? "", clien_id: "b996b9002c9d463b85daac04298e2f1b", clien_secret: "de031e609d1141f2a014eb6805f80f9b")
            self.viewModel.doLogout(userToken: user)
            self.viewModel.logout()
        }
        let actionNo = UIAlertAction(title: Constants.Text.Sheet.no, style: .destructive)
        view.addAction(actionYes)
        view.addAction(actionNo)
        return view
    }()
    
    private lazy var logoutAlertController: UIAlertController = {
        let view = UIAlertController(title: Constants.Text.Profile.title, message: nil, preferredStyle: .actionSheet)
        let actionExit = UIAlertAction(title: Constants.Text.Sheet.doExit, style: .destructive){_ in
            self.present(self.popLogoutAlertController, animated: true, completion: nil)
        }
        let actionCancel = UIAlertAction(title: Constants.Text.Sheet.cancel, style: .cancel)
        view.addAction(actionExit)
        view.addAction(actionCancel)
        return view
    }()
    
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
   
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(statusObs(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
        view.backgroundColor = .white
        setupViews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(logout))
        makeCircle()
        makeConstraints()
        bind()
        viewModel.getInformationAboutDisk()
    }
    
    private func bind(){
        viewModel.profileObs.bind {[weak self] array in
            guard let self = self else {return}
            guard
                let max = array?.maxSize,
                let used = array?.usedSize,
                let free = array?.freeSize,
                let percent = array?.percent
            else {return}
            self.labelTotal.text = "\(Int(max))" + Constants.Text.Profile.totalSize
            self.labelUsed.text = "\(used)" + Constants.Text.Profile.usedSize
            self.labelFree.text = "\(free)" + Constants.Text.Profile.freeSize
            self.strokeEndValue = percent
            self.animateCircle()
        }
    }

    private func setupViews(){
        view.addSubview(circleView)
        view.addSubview(viewInfo)
        view.addSubview(labelTotal)
        view.addSubview(lostConnectionView)
        circleView.layer.addSublayer(shadowLayer)
        circleView.layer.addSublayer(shapeLayer)
        circleView.bounds = CGRect(x: view.frame.width / -2, y: 270 / -2, width: view.frame.width, height: 270)
    }
    
    private func makeConstraints(){
        
        lostConnectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        circleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(viewInfo.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(270)
        }
        viewInfo.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.top.equalTo(circleView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        imageUsed.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(35)
            make.top.equalTo(circleView.snp.bottom).offset(12)
            make.height.width.equalTo(27)
        }
        imageFree.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(35)
            make.top.equalTo(imageUsed.snp.bottom).offset(16)
            make.height.width.equalTo(27)
        }
        labelUsed.snp.makeConstraints { make in
            make.top.equalTo(circleView.snp.bottom).offset(18)
            make.left.equalTo(imageUsed).inset(35)
        }
        labelFree.snp.makeConstraints { make in
            make.top.equalTo(labelUsed.snp.bottom).offset(28)
            make.left.equalTo(imageFree).inset(35)
        }
        buttonPublished.snp.makeConstraints { make in
            make.top.equalTo(labelFree).offset(60)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(45)
        }
        labelTotal.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(127)
            make.left.equalTo(view.snp.left).inset(172)
        }


    }
    private func makeCircle(){
        let pop = circleView.center
        let circlePathShape = UIBezierPath(arcCenter: pop , radius: 80, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        shadowLayer.path = circlePathShape.cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        shadowLayer.strokeColor = Constants.Colors.mainGrey?.cgColor
        shadowLayer.lineWidth = 40
    
        shapeLayer.path = circlePathShape.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = Constants.Colors.mainPink?.cgColor
        shapeLayer.lineWidth = 40
        shapeLayer.strokeEnd = 0
    }
    
    private func animateCircle(){
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = strokeEndValue
        animation.duration = 0.8
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "basic")
    }
    
    @objc private func buttonTapped(){
        viewModel.openPosted()
    }
    
    @objc private func logout(){
        present(logoutAlertController, animated: true, completion: nil)
    }
    
    @objc private func statusObs(notification: Notification){
        if NetworkMonitor.shared.isConnected {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5){
                    self.lostConnectionView.alpha = 1
                }
            }
        } else {
            viewModel.getInformationAboutDisk()
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5){
                    self.lostConnectionView.alpha = 0
                }
            }
        }
    }
}
