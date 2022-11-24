//
//  EditVC.swift
//  Diplom
//
//  Created by Nor1 on 17.08.2022.
//

import Foundation
import UIKit

class EditVC : UIViewController {
    
    private var viewModel: FilesViewModel
    private var path = ""
    private var name = ""
    private var file = ""
    private var image : UIImage?
    
    init(viewModel: FilesViewModel, path: String, title: String, file: String, image: UIImage) {
        self.viewModel = viewModel
        self.path = path
        self.name = title
        self.file = file
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    private lazy var textField : UITextField = {
        let view = UITextField()
        view.keyboardType = .alphabet
        view.borderStyle = .none
        view.text = name
        view.clearButtonMode = .never
        view.rightViewMode = .whileEditing
        view.rightView = closeCircle
        view.returnKeyType = .done
        return view
    }()
    
    private lazy var imageView: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.contentMode = .scaleToFill
        view.image = image
        return view
    }()
    
    private lazy var buttonPublished : UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor.white
        config.image = nil
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
        view.addSubview(textField)
        view.addSubview(imageView)
        return view
    }()
    
    private lazy var buttonDelete : UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        let title = Constants.Text.Edit.delete
        let attr : [NSAttributedString.Key: Any] = [
            .font : Constants.Fonts.button16 as Any,
            .foregroundColor : Constants.Colors.mainBlack as Any
        ]
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer(attr))
        config.titleAlignment = .leading
        config.baseBackgroundColor = UIColor.white
        config.imagePlacement = .trailing
        config.imagePadding = 110
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 4)
        config.cornerStyle = .medium
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 120)
        view.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.08)
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.4)
        view.layer.shadowOpacity = 1
        
        view.configuration = config
        view.isHidden = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonDeleteTapped)))
        return view
    }()
    private lazy var buttonShare : UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        let title = Constants.Text.Edit.share
        let attr : [NSAttributedString.Key: Any] = [
            .font : Constants.Fonts.button16 as Any,
            .foregroundColor : Constants.Colors.mainBlack as Any
        ]
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer(attr))
        config.titleAlignment = .leading
        config.baseBackgroundColor = UIColor.white
        config.imagePlacement = .trailing
        config.imagePadding = 110
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 4)
        config.cornerStyle = .medium
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 120)
        view.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.08)
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.4)
        view.layer.shadowOpacity = 1
        
        view.configuration = config
        view.isHidden = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonShareTapped)))
        return view
    }()
    
    private lazy var closeCircle : UIButton = {
       let view = UIButton()
        view.setImage(UIImage(named: "close_circle"), for: .normal)
        view.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        return view
    }()
   
    private lazy var errorAlert : UIAlertController = {
        let view = UIAlertController(title: Constants.Text.Sheet.refresh, message: nil, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: Constants.Text.Sheet.ok, style: .cancel){ action in
        }
        view.addAction(actionCancel)
        return view
    }()
    
    private lazy var deleteSheet : UIAlertController = {
        let view = UIAlertController(title: Constants.Text.Sheet.deleteDocWarning, message: nil, preferredStyle: .actionSheet)
        let actionDelete = UIAlertAction(title: Constants.Text.Sheet.deleteDoc, style: .destructive){ action in
            self.viewModel.deleteFile(path: self.path){ bool in
                switch bool {
                case true:
                    self.navigationController?.popViewController(animated: true)
                    FilesViewModel.isDeleted = true
                case false:
                    self.present(self.errorAlert, animated: true, completion: nil)
                }
            }
        }
        let actionCancel = UIAlertAction(title: Constants.Text.Sheet.cancel, style: .cancel){ action in
        }
        view.addAction(actionDelete)
        view.addAction(actionCancel)
        return view
    }()
    private lazy var shareSheet : UIAlertController = {
        let view = UIAlertController(title: Constants.Text.Sheet.share, message: nil, preferredStyle: .actionSheet)
        let actionUrl = UIAlertAction(title: Constants.Text.Sheet.viaLink, style: .default){ action in
            let link = self.file
            let linkToShare = [link]
            let activitiVC = UIActivityViewController(activityItems: linkToShare, applicationActivities: nil)
            activitiVC.popoverPresentationController?.sourceView = self.view
            activitiVC.excludedActivityTypes = [.postToVimeo,.postToFacebook]
            self.present(activitiVC, animated: true)
        }
        let actionCancel = UIAlertAction(title: Constants.Text.Sheet.cancel, style: .cancel){ action in
        }
        view.addAction(actionUrl)
        view.addAction(actionCancel)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        makeConstraints()
        textField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.Images.compliteImage, style: .plain, target: nil, action: #selector(doComplite))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Colors.mainBlue
        navigationItem.rightBarButtonItem?.setBackgroundVerticalPositionAdjustment(2, for: .default)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let attrNavigationBar = [
                    NSAttributedString.Key.font: Constants.Fonts.headerFont17 as Any,
                    NSAttributedString.Key.foregroundColor: Constants.Colors.mainWhite as Any
                ]
        navigationController?.navigationBar.titleTextAttributes = attrNavigationBar
        FilesViewModel.docVC = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FilesViewModel.docVC == true {
            buttonDelete.isHidden = false
            buttonShare.isHidden = false
        }
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        view.addSubview(buttonPublished)
        view.addSubview(buttonDelete)
        view.addSubview(buttonShare)
    }
    
    private func makeConstraints(){
        buttonPublished.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().inset(18)
            make.height.equalTo(50)
        }
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(buttonPublished.snp.centerY)
            make.right.equalTo(buttonPublished.snp.right).inset(15)
            make.left.equalTo(imageView.snp.right).offset(10)
            
        }
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalTo(buttonPublished.snp.centerY)
            make.top.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(14)
            make.width.equalTo(26)
        }
        buttonDelete.snp.makeConstraints { make in
            make.top.equalTo(buttonPublished.snp.bottom).offset(25)
            make.right.equalToSuperview().inset(25)
            make.width.equalTo(150)
            make.height.equalTo(70)
        }
        buttonShare.snp.makeConstraints { make in
            make.top.equalTo(buttonPublished.snp.bottom).offset(25)
            make.left.equalToSuperview().inset(25)
            make.width.equalTo(150)
            make.height.equalTo(70)
        }
    }
    
    @objc private func clearTextField(){
        textField.text = ""
    }
    @objc private func doComplite(){
        if textField.text == "" || textField.text == self.name{
            
            textField.text = self.name
            textField.resignFirstResponder()
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            if let text = textField.text {
                viewModel.networkService.changeName(path: path, newName: text){bool in
                    print(bool)
                    if bool == true {
                        self.navigationController?.popViewController(animated: true)
                        FilesViewModel.changedName = self.textField.text
                        FilesViewModel.isChanged = true
                    } else {
                        self.present(self.errorAlert, animated: true, completion: nil)
                    }
                }
            }
        textField.resignFirstResponder()
        navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

extension EditVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" || textField.text == self.name {
            textField.text = self.name
            textField.resignFirstResponder()
            navigationItem.rightBarButtonItem?.isEnabled = false
            return true
        } else {
            if let text = textField.text{
                viewModel.networkService.changeName(path: path, newName: text){ bool in
                    switch bool {
                    case true:
                        self.navigationController?.popViewController(animated: true)
                        FilesViewModel.changedName = self.textField.text
                        FilesViewModel.isChanged = true
                    case false:
                        self.present(self.errorAlert, animated: true, completion: nil)
                    }
                }
            }
        textField.resignFirstResponder()
        navigationItem.rightBarButtonItem?.isEnabled = false
        return true
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if textField.text == ""{
            textField.text = self.name
            view.endEditing(true)
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
        view.endEditing(true)
        navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc private func buttonDeleteTapped(){
        present(deleteSheet, animated: true, completion: nil)
    }
    @objc private func buttonShareTapped(){
        present(shareSheet, animated: true, completion: nil)
    }
}
