//
//  OnboardingCollectionViewCell.swift
//  Diplom
//
//  Created by Nor1 on 15.11.2022.
//

import Foundation
import UIKit

class OnboardingCollectionViewCell : UICollectionViewCell {
    static var identifier = "OnboardingCVCell"
    
    private lazy var imageViewCVC: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(systemName: "folder")
        view.contentMode = .bottom
        view.clipsToBounds = true
       return view
    }()
    
    private lazy var labelCVC: UILabel = {
        let view = UILabel()
        view.text = "TEST"
        view.font = Constants.Fonts.headerFont17
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews(){
        contentView.addSubview(imageViewCVC)
        contentView.addSubview(labelCVC)
    }
    private func makeConstraints(){
        imageViewCVC.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(190)
            make.left.right.equalToSuperview()
            make.top.equalTo(contentView.snp.top).offset(80)
        }
        labelCVC.snp.makeConstraints { make in
            make.top.equalTo(imageViewCVC.snp.bottom).offset(40)
            make.height.equalTo(80)
            make.width.equalTo(263)
            make.centerX.equalToSuperview()
        }
    }
    
    func setup(_ slide: OnboardingSlide){
        imageViewCVC.image = slide.image
        labelCVC.text = slide.description
    }
}
