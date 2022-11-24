//
//  ImageVC.swift
//  Diplom
//
//  Created by Nor1 on 22.07.2022.
//

import Foundation
import UIKit
import SnapKit

class ImageVC : UIViewController {
    private var viewModel : FilesViewModel
    var path = ""
    var date = ""
    var onDisk = ""
    private var isZoomed = false
    
    init(viewModel: FilesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageViewToShow : UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        view.addSubview(titleDate)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var titleDate : UILabel = {
       let view = UILabel()
        view.text = date
        view.textColor = Constants.Colors.mainGrey
        view.font = Constants.Fonts.smallBody13
        view.textAlignment = .center
        return view
    }()
    private lazy var shareButton : UIButton = {
        let view = UIButton()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentShare)))
        view.isEnabled = false
        return view
    }()
    
    private lazy var deleteButton : UIButton = {
        let view = UIButton()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentDelete)))
        view.isEnabled = false
        return view
    }()
    
    private lazy var indicator : UIActivityIndicatorView = {
       let view = UIActivityIndicatorView()
        view.color = Constants.Colors.mainWhite
        return view
    }()
    
    private lazy var pencilButton : UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(named: "pencil"), style: .plain, target: self, action: #selector(editPressed))
        view.isEnabled = false
        return view
    }()
    
    private lazy var deleteSheet : UIAlertController = {
        let view = UIAlertController(title: Constants.Text.Sheet.deleteImageWarning, message: nil, preferredStyle: .actionSheet)
        let actionDelete = UIAlertAction(title: Constants.Text.Sheet.deleteImage, style: .destructive){ action in
            self.viewModel.deleteFile(path: self.onDisk){ bool in
                switch bool {
                case true:
                    self.navigationController?.popViewController(animated: true)
                    FilesViewModel.isDeleted = true
                case false:
                    self.present(self.popAlertError, animated: true, completion: nil)
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
        let actionFile = UIAlertAction(title: Constants.Text.Sheet.viaFile, style: .default){ action in
            let image = self.imageViewToShow.image
            let imageToShare = [self.title]
            let activitiVC = UIActivityViewController(activityItems: imageToShare as [Any], applicationActivities: nil)
            activitiVC.tabBarItem.image = self.imageViewToShow.image
            activitiVC.popoverPresentationController?.sourceView = self.view
            activitiVC.excludedActivityTypes = [.postToVimeo,.postToFacebook]
            self.present(activitiVC, animated: true)
        }
        let actionUrl = UIAlertAction(title: Constants.Text.Sheet.viaLink, style: .default){ action in
            let link = self.path
            let linkToShare = [link]
            let activitiVC = UIActivityViewController(activityItems: linkToShare, applicationActivities: nil)
            activitiVC.popoverPresentationController?.sourceView = self.view
            activitiVC.excludedActivityTypes = [.postToVimeo,.postToFacebook]
            self.present(activitiVC, animated: true)
        }
        let actionCancel = UIAlertAction(title: Constants.Text.Sheet.cancel, style: .cancel){ action in
        }
        view.addAction(actionFile)
        view.addAction(actionUrl)
        view.addAction(actionCancel)
        return view
    }()
    
    private lazy var popAlertError : UIAlertController = {
        let view = UIAlertController(title: Constants.Text.Sheet.refresh, message: nil, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: Constants.Text.Sheet.ok, style: .default){ action in
        }
        view.addAction(actionCancel)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        makeConstraints()
        navigationItem.rightBarButtonItem = pencilButton
        indicator.startAnimating()
        viewModel.networkService.getImageForCell(path: path){ image in
            self.imageViewToShow.image = image
            self.shareButton.isEnabled = true
            self.deleteButton.isEnabled = true
            self.pencilButton.isEnabled = true
            self.indicator.stopAnimating()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FilesViewModel.isChanged == true {
            title = FilesViewModel.changedName
            if FilesViewModel.isChanged == true {
                deleteButton.isEnabled = false
                shareButton.isEnabled = false
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let attrNavigationBar = [
                    NSAttributedString.Key.font: Constants.Fonts.headerFont17 as Any,
                    NSAttributedString.Key.foregroundColor: Constants.Colors.mainBlack as Any
                ]
        navigationController?.navigationBar.titleTextAttributes = attrNavigationBar
        tabBarController?.tabBar.isHidden = false
    }

    private func setupViews(){
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        deleteButton.setImage(UIImage(named: "delete"), for: .normal)
        imageViewToShow.addSubview(shareButton)
        imageViewToShow.addSubview(deleteButton)
        imageViewToShow.addSubview(titleDate)
        view.addSubview(imageViewToShow)
        imageViewToShow.addSubview(indicator)
        view.backgroundColor = Constants.Colors.mainBlack
        

    }
    
    private func makeConstraints(){
        shareButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(25)
        }
        deleteButton.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).inset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(27)
        }
        imageViewToShow.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        indicator.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        titleDate.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
    }
    
    @objc private func didTap(){
        if isZoomed {
            shareButton.setImage(UIImage(named: "share"), for: .normal)
            deleteButton.setImage(UIImage(named: "delete"), for: .normal)
            imageViewToShow.contentMode = .scaleAspectFit
            titleDate.textColor = Constants.Colors.mainGrey
            pencilButton.tintColor = Constants.Colors.mainGrey
            UINavigationBar.appearance().backIndicatorImage = nil
            isZoomed = false
        }
        else {
            shareButton.setImage(UIImage(named: "share_white"), for: .normal)
            deleteButton.setImage(UIImage(named: "delete_white"), for: .normal)
            titleDate.textColor = Constants.Colors.mainWhite
            pencilButton.tintColor = Constants.Colors.mainWhite
            imageViewToShow.contentMode = .scaleAspectFill
            imageViewToShow.clipsToBounds = true
            isZoomed = true
        }
    }
    
    @objc private func presentDelete(){
        present(deleteSheet, animated: true, completion: nil)
    }
    @objc private func presentShare(){
        present(shareSheet, animated: true, completion: nil)
    }
    @objc private func editPressed(){
        viewModel.openEdit(title: title ?? "ERROR", path: onDisk, file: path, image: imageViewToShow.image ?? UIImage())
    }
}




