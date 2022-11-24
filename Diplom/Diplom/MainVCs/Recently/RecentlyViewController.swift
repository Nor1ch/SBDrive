//
//  RecentlyViewController.swift
//  Diplom
//
//  Created by Nor1 on 05.07.2022.
//

import UIKit

class RecentlyViewController : UIViewController {
    private var viewModel : FilesViewModel
    private var delegate : TableViewForDelegate?
    var path = "disk:/"
    init(viewModel: FilesViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
       let view = UITableView()
        return view
    }()
    private lazy var indicator: UIActivityIndicatorView = {
       let view = UIActivityIndicatorView()
        return view
    }()
    private lazy var labelError : UILabel = {
       let view = UILabel()
        view.font = Constants.Fonts.headerFont17
        view.text = Constants.Text.Recently.empty
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        return view
    }()
    private lazy var refresher : UIRefreshControl = {
       let view = UIRefreshControl()
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
        bind()
        setupViews()
        makeConstraints()
        viewModel.getRecentlyFiles(isRefresh: false)
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        tableView.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.identifier)
        tableView.separatorStyle = .none
        tableView.isHidden = true
    }
    
    private func bind(){
        viewModel.recentlyObs.bind { array in
            self.refresher.endRefreshing()
            self.indicator.stopAnimating()
            if array.isEmpty {
                guard let _ = self.delegate else {
                    self.refresher.endRefreshing()
                    self.indicator.stopAnimating()
                    self.view.addSubview(self.labelError)
                    self.labelError.snp.makeConstraints { make in
                        make.width.equalTo(263)
                        make.height.equalTo(38)
                        make.centerY.equalTo(self.view.snp.centerY).offset(-30)
                        make.centerX.equalTo(self.view.snp.centerX)
                    }
                    return
                }
            } else {
            self.delegate = TableViewForDelegate(array: array, model: self.viewModel, path: self.path)
            self.tableView.dataSource = self.delegate
            self.tableView.delegate = self.delegate
            self.indicator.stopAnimating()
            self.tableView.reloadData()
            self.tableView.isHidden = false
            }
        }
    }
    private func setupViews(){
        view.backgroundColor = Constants.Colors.mainWhite
        view.addSubview(tableView)
        view.addSubview(indicator)
        view.addSubview(lostConnectionView)
        tableView.addSubview(refresher)
        tableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    @objc private func pullToRefresh(){
        viewModel.getRecentlyFiles(isRefresh: true)
    }
    private func makeConstraints(){
        lostConnectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        indicator.snp.makeConstraints { make in
            indicator.startAnimating()
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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

