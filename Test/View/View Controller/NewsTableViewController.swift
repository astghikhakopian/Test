//
//  NewsTableViewController.swift
//  Test
//
//  Created by Astghik Hakopian on 11/5/20.
//

import RxDataSources
import RxSwift

class NewsTableViewController: UITableViewController {
    
    // MARK: - Standard
    
    var newsViewModel: NewsViewModel? {
        didSet {
            bindViewModel()
            setContent()
        }
    }
    let disposeBag = DisposeBag()
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSettings()
        addNotificationObservers()
    }
    
    @objc func applicationDidBecomeActive() {
        tableView.backgroundColor = AppColor.backgrund
    }
    
    @objc func applicationWillResignActive() {
        tableView.backgroundColor = AppColor.oppositeBackgrund
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - Custom lifecycle

extension NewsTableViewController {
    
    private func configureSettings() {
        
        tableView.register(UINib(nibName: NewsTableViewCell.id, bundle: nil), forCellReuseIdentifier: NewsTableViewCell.id)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.tableFooterView = UIView()
    }
    
    private func setContent() {
        
        newsViewModel?.getNewsList()
    }
    
    @objc private func reloadData() {
        
        newsViewModel?.getNewsList()
    }
    
    private func bindViewModel() {
        
        bindCommonIndicators()
        bindTableviewDataSource()
        bindCellSelection()
    }
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
}

// MARK: - Private Methods

extension NewsTableViewController {
    
    private func setMessage(_ message: String?) {
        guard let message = message else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return
        }
        
        tableView.separatorStyle = .none
        let messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        tableView.backgroundView = messageLabel
    }
}


// MARK: - Binding

extension NewsTableViewController {
    
    // table view
    
    private func bindTableviewDataSource() {
        tableView.delegate = nil
        tableView.dataSource = nil
        newsViewModel?.localNewsCells.bind(to: tableView.rx.items) { [unowned self] tableView, index, element in
            self.makeCell(with: element, from: tableView, indexPath: IndexPath(row: index, section: 0))
        }.disposed(by: disposeBag)
    }
    
    private func bindCellSelection() {
        tableView.rx.itemSelected.subscribe(
            onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                
                guard  let cellValues = self.newsViewModel?.localNewsCells.value, indexPath.item < cellValues.count else { return }
                let cellType = cellValues[indexPath.item]
                
                guard let cellViewModel = cellType.cellViewModel,
                      let splitViewController = self.splitViewController as? PrimarySplitViewController,
                      let destinationVC = splitViewController.newsDetailsVC  else { return }
                self.newsViewModel?.gotSelectedNews.accept(cellViewModel)
                self.newsViewModel?.gotReadNews.accept(cellViewModel)
                
                destinationVC.navigationController?.popToRootViewController(animated: true)
                let destinationNC = UINavigationController(rootViewController: destinationVC)
                self.splitViewController?.showDetailViewController(destinationNC, sender: nil)
        }).disposed(by: disposeBag)
    }
    
    private func makeCell(with element: NewsCellType, from tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch element {
        case .normal(let cellViewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.id, for: indexPath) as! NewsTableViewCell
            
            cell.viewModel = cellViewModel
            setMessage(nil)
            
            return cell
        case .error(let message):
            let cell = UITableViewCell()
            setMessage(message)
            cell.isUserInteractionEnabled = false
            return cell
        case .empty:
            let cell = UITableViewCell()
            setMessage("No Data Available") // TODO: - Localize
            cell.isUserInteractionEnabled = false
            return cell
        }
    }
    
    
    // common alerts, loading
    
    private func bindCommonIndicators() {
        
        newsViewModel?.showLoadingHud
            .map { [weak self] loading in
                guard let self = self else { return }
                if loading {
                    if !self.tableView.refreshControl!.isRefreshing {
                        let activityIndicator = UIActivityIndicatorView()
                        activityIndicator.startAnimating()
                        self.tableView.backgroundView = activityIndicator
                    }
                } else {
                    self.tableView.refreshControl!.endRefreshing()
                    self.tableView.backgroundView = nil
                }
            }.subscribe().disposed(by: disposeBag)
        
        newsViewModel?.onShowError
            .map { [weak self] in self?.present(alert: $0)}
            .subscribe().disposed(by: disposeBag)
    }
}

extension NewsTableViewController: AlertContainerDelegate {}
