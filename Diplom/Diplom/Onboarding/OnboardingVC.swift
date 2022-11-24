//
//  OnboardingVC.swift
//  Diplom
//
//  Created by Nor1 on 15.11.2022.
//

import Foundation
import UIKit
import SnapKit

class OnboardingVC : UIViewController {
    private let viewModel: OnboardingViewModel
    private let slides: [OnboardingSlide]
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    init(viewModel: OnboardingViewModel){
        self.viewModel = viewModel
        self.slides = viewModel.slides
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isPagingEnabled = true
        return view
    }()
    
    private lazy var pageControl: UIPageControl = {
       let view = UIPageControl()
        view.numberOfPages = 3
        view.currentPageIndicatorTintColor = Constants.Colors.mainBlue
        view.pageIndicatorTintColor = Constants.Colors.mainGrey
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var nextButton: UIButton = {
        let view = UIButton()
        let buttonTitle = Constants.Text.Onboarding.buttonNext
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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextButtontapped)))
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.mainWhite
        setupViews()
        makeConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
    }
    
    private func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top)
            make.height.equalTo(100)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(80)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(320)
        }
    }
    
    @objc private func nextButtontapped(){
        currentPage += 1
        if currentPage < slides.count {
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            viewModel.openLogin()
        }
    }
}

extension OnboardingVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
}

extension OnboardingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
