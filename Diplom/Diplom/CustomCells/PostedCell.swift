//
//  PostedCell.swift
//  Diplom
//
//  Created by Nor1 on 15.08.2022.
//

import Foundation
import UIKit

class PostedCell : UITableViewCell {
    
    static var identifier: String = "postedCell"
    
    private lazy var changeButton : UIButton = {
       let view = UIButton()
        view.setImage(UIImage(named: "Menu"), for: .normal)
        return view
    }()
    
    private lazy var imageViewCell : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    private lazy var titleCell : UILabel = {
       let view = UILabel()
        view.font = Constants.Fonts.mainBody15
        return view
    }()
    private lazy var indicator: UIActivityIndicatorView = {
       let view = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        return view
    }()
    private lazy var timeCell : UILabel = {
       let view = UILabel()
        view.font = Constants.Fonts.smallBody13
        view.textColor = Constants.Colors.mainGrey
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageViewCell)
        contentView.addSubview(titleCell)
        contentView.addSubview(timeCell)
        contentView.addSubview(changeButton)
        imageViewCell.addSubview(indicator)
        indicator.startAnimating()

    }
    
    private func makeConstraints() {
        imageViewCell.snp.makeConstraints { make in
            make.width.equalTo(26)

            make.left.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(13)
            make.bottom.equalToSuperview().inset(14)
            
        }
        titleCell.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(imageViewCell.snp.right).offset(15)
            make.right.equalToSuperview()
        }
        timeCell.snp.makeConstraints { make in
            make.top.equalTo(titleCell).offset(12)
            make.left.equalTo(imageViewCell.snp.right).offset(15)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        indicator.snp.makeConstraints { make in
            make.centerX.equalTo(imageViewCell.snp.centerX)
            make.centerY.equalTo(imageViewCell.snp.centerY)
        }
        
        changeButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalToSuperview()
        }

    }
    
    func getImage() -> UIImageView {
        imageViewCell
    }
    
    func getTitle() -> UILabel {
        titleCell
    }
    func getTime() -> UILabel {
        timeCell
    }
    func getIndicator() -> UIActivityIndicatorView {
        indicator
    }
}
