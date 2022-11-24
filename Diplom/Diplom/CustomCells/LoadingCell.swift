//
//  LoadingCell.swift
//  Diplom
//
//  Created by Nor1 on 26.07.2022.
//

import Foundation
import UIKit

class LoadingCell : UITableViewCell {
    static let identifier = "loadingCell"
    
    private lazy var indicator : UIActivityIndicatorView = {
       let view = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
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
    
    private func setupViews(){
        contentView.addSubview(indicator)
    }
    
    private func makeConstraints(){
        indicator.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    func getIndicator() -> UIActivityIndicatorView {
        indicator
    }
}
