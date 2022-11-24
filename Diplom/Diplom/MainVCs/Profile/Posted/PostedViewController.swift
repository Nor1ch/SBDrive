//
//  PostedViewController.swift
//  Diplom
//
//  Created by Nor1 on 13.07.2022.
//

import UIKit

class PostedViewController : UIViewController {
    private var viewModel: FilesViewModel
    private var delegate : TableViewForDelegate?
    private let path = "disk:/"
    
    init(viewModel: FilesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageViewError: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "emptyFolder")
        return view
    }()
    
    private lazy var tableView : UITableView = {
       let view = UITableView()
        return view
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
       let view = UIActivityIndicatorView()
        return view
    }()
    private lazy var refresher : UIRefreshControl = {
        let view = UIRefreshControl()
        return view
    }()
    
    private lazy var labelError : UILabel = {
        let view = UILabel()
        view.text = Constants.Text.Published.empty
        view.font = Constants.Fonts.headerFont17
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var refreshButton : UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        let attr : [NSAttributedString.Key: Any] = [
            .font : Constants.Fonts.button16 as Any,
            .foregroundColor : Constants.Colors.mainBlack as Any
        ]
        let title = Constants.Text.Published.refresh
        config.titleAlignment = .center
        config.baseBackgroundColor = Constants.Colors.mainPink
        config.baseForegroundColor = Constants.Colors.mainBlack
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer(attr))
        config.cornerStyle = .medium
        view.configuration = config
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let _ = delegate else {return}
        if let row = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: row, animated: true)
            if FilesViewModel.isDeleted == true {
            tableView.beginUpdates()
            delegate?.arrayForTableView.remove(at: row.row)
            tableView.deleteRows(at: [row], with: .fade)
            tableView.endUpdates()
            FilesViewModel.isDeleted = false
            }
            if FilesViewModel.isChanged == true {
                if let item = delegate?.arrayForTableView[row.row]{
                    let newItem = DiskFileModel(name: FilesViewModel.changedName, created: item.created, path: item.path, type: item.type, file: item.file, preview: item.preview, media_type: item.media_type, total: item.total, size: item.size, preview_loaded: item.preview_loaded, file_loaded: item.file_loaded)
                    delegate?.arrayForTableView[row.row] = newItem
                    tableView.reloadData()
                FilesViewModel.isChanged = false
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(statusObs(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
        binding()
        setupViews()
        makeConstraints()
        viewModel.getPostedFiles(isRefresh: false)
        view.backgroundColor = Constants.Colors.mainWhite
        tableView.isHidden = true
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        tableView.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.identifier)
        tableView.separatorStyle = .none
        refreshButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    @objc private func tapped(){
        imageViewError.removeFromSuperview()
        labelError.removeFromSuperview()
        refreshButton.removeFromSuperview()
        indicator.startAnimating()
        viewModel.getPostedFiles(isRefresh: false)
    }
    
    private func binding(){
        viewModel.postedObs.bind { array in
            self.refresher.endRefreshing()
            self.indicator.stopAnimating()
            if array.isEmpty {
                self.view.addSubview(self.imageViewError)
                self.view.addSubview(self.labelError)
                self.view.addSubview(self.refreshButton)
                self.makeConstraintsWithError()
            } else {
            self.delegate = TableViewForDelegate(array: array, model: self.viewModel, path: self.path)
            self.delegate?.vc = self
            self.tableView.dataSource = self.delegate
            self.tableView.delegate = self.delegate
            self.tableView.reloadData()
            self.tableView.isHidden = false
            }
        }
    }
    private func setupViews(){
        view.addSubview(tableView)
        view.addSubview(indicator)
        view.addSubview(lostConnectionView)
        tableView.addSubview(refresher)
        tableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    private func makeConstraints(){
   
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        indicator.snp.makeConstraints { make in
            indicator.startAnimating()
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        lostConnectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func makeConstraintsWithError(){
        imageViewError.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(133)
        }
        labelError.snp.makeConstraints { make in
            make.top.equalTo(imageViewError.snp.bottom).offset(35)
            make.left.right.equalToSuperview().inset(90)
        }
        refreshButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(labelError.snp.bottom).offset(222)
            make.left.right.equalToSuperview().inset(28)
        }
    }
    
    @objc private func pullToRefresh(){
        viewModel.getPostedFiles(isRefresh: true)
        
    }
    
    @objc private func statusObs(notification: Notification){
        if NetworkMonitor.shared.isConnected {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5){
                    self.lostConnectionView.alpha = 0
                }
            }
        } else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5){
                    self.lostConnectionView.alpha = 1
                }
            }
        }
    }
}
