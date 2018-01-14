import UIKit
import RxSwift
import RxCocoa

final class QiitaItemsListViewController: UIViewController {
    
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public properties -
    
    var presenter: QiitaItemsListPresenterInterface!
    var didReachedBottom: Signal<Void>
    
    // MARK: - Private properties -
    
    private var didReachedBottomRelay: PublishRelay<Void>
    
    
    private var cellHeightList: [IndexPath: CGFloat] = [:]
    private var imageLoadQueue = OperationQueue()
    private var imageLoadOperations = [IndexPath: ImageLoadOperation]()
    private var searchController = UISearchController(searchResultsController: nil)
    
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Lifecycle -
    
    required init?(coder aDecoder: NSCoder) {
        
        let didReachedBottomRelay = PublishRelay<Void>()
        self.didReachedBottomRelay = didReachedBottomRelay
        self.didReachedBottom = didReachedBottomRelay.asSignal()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
        _setTableView()
        // presenter.viewDidLoad()
    }
    
    private func _setupUI() {
        navigationItem.title = "List"
        
        definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        
        presenter.didStateChange.emit(onNext: { [weak self] state in
            
            guard let `self` = self else { return }
            
            if state.state == .requestFinished {
                self.hideLoading()
                self.refreshControl.endRefreshing()
            }
            
            if state.state == .requestFinished
                && state.trigger == .searchTextChange {
                
                DispatchQueue.main.async {
                    self.scrolltoTop()
                }
            }
        })
        .disposed(by: disposeBag)
        
        presenter.didErrorChange.emit(onNext: { [weak self] error in

            guard let `self` = self else { return }

            self.showErrorAlert(with: error.localizedDescription) { _ in
                self.hideLoading()
                self.refreshControl.endRefreshing()
            }
        })
        .disposed(by: disposeBag)
        
        presenter.bind(input: (
            searchBarText: searchController.searchBar.rx.text
                .orEmpty
                .debounce(0.2, scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .asDriver(onErrorJustReturn: ""),
            didItemSelect: tableView.rx
                .modelSelected(QiitaItem.self)
                .asDriver(),
            didReachBottom: didReachedBottom,
            searchBarCancelTap: searchController.searchBar.rx
                .cancelButtonClicked.asSignal(),
            refreshDidChange: refreshControl.rx
                .controlEvent(.valueChanged)
                .asSignal()
        ))
    }
    
    private func _setTableView() {
        
        tableView.register(QiitaItemTableViewCell.self)
        tableView.refreshControl = self.refreshControl
        
        tableView.tableFooterView = UIView()
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = self.searchController
            self.navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            tableView.tableHeaderView = self.searchController.searchBar
        }
        
        if #available(iOS 10.0, *) {
            tableView.prefetchDataSource = self
        }
        
        tableView.rx.reachBottom.asSignal(onErrorSignalWith: .empty())
            .emit(onNext: { [weak self] _ in
                
                guard let `self` = self else { return }
                
                self.didReachedBottomRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell.asDriver()
            .drive(onNext: { [weak self] (cell, indexPath) in
                
                guard let `self` = self else { return }
                
                if !self.cellHeightList.keys.contains(indexPath) {
                    self.cellHeightList[indexPath] = cell.frame.size.height
                }
            }).disposed(by: disposeBag)
        
        tableView.rx.didEndDisplayingCell.asDriver()
            .drive(onNext: { [weak self] cell, indexPath in
                
                guard let `self` = self else { return }
                
                guard let imageLoadOperation = self.imageLoadOperations[indexPath] else { return }
                
                imageLoadOperation.cancel()
                
                self.imageLoadOperations.removeValue(forKey: indexPath)
            })
            .disposed(by: disposeBag)
        
        presenter.didItemsChange.drive(tableView.rx.items) { [weak self] (tableView, row, element) in
            
            guard let `self` = self else { return UITableViewCell() }
            
            let indexPath = IndexPath(row: row, section: 0)
            
            return self.configureCell(indexPath: indexPath, item: element)
            }
            .disposed(by: disposeBag)
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    private func configureCell(indexPath: IndexPath, item: QiitaItem) -> QiitaItemTableViewCell {
        
        let cell: QiitaItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(item: item)
        
        if let imageLoadOperation = self.imageLoadOperations[indexPath],
            let image = imageLoadOperation.image {
            cell.profileImageView.setRoundedImage(image)
        } else {
            guard let url = item.user?.profile_image_url else {
                return cell
            }
            let imageLoadOperation = ImageLoadOperation(url: url)
            imageLoadOperation.completionHandler = { [weak self] image in
                guard let `self` = self else {
                    return
                }
                cell.profileImageView.setRoundedImage(image)
                self.imageLoadOperations.removeValue(forKey: indexPath)
            }
            imageLoadQueue.addOperation(imageLoadOperation)
            imageLoadOperations[indexPath] = imageLoadOperation
        }
        return cell
    }
}

// MARK: - Extensions -

extension QiitaItemsListViewController: QiitaItemsListViewInterface {
    
    func scrolltoTop() {
        
        let indexPath = IndexPath(row: 0, section: 0)
        guard let _ = presenter.itemAt(indexPath) else {
            return
        }
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
}

extension QiitaItemsListViewController: StoryboardLoadable {
    static var storyboardName: String {
        return StoryboardName.QiitaItemsListViewController.name
    }
}

extension QiitaItemsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !cellHeightList.keys.contains(indexPath) {
            cellHeightList[indexPath] = cell.frame.size.height
        }
        
        let isLastCell = (presenter.numberOfRows() - 1 == indexPath.row)
        
        if isLastCell {
            didReachedBottomRelay.accept(())
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = cellHeightList[indexPath] {
            return height
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
}

extension QiitaItemsListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if let _ = imageLoadOperations[indexPath] {
                return
            }
            
            guard let item = presenter.itemAt(indexPath),
                let url = item.user?.profile_image_url else {
                    return
            }
            let imageLoadOperation = ImageLoadOperation(url: url)
            imageLoadOperations[indexPath] = imageLoadOperation
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            guard let imageLoadOperation = imageLoadOperations[indexPath] else {
                return
            }
            imageLoadOperation.cancel()
            imageLoadOperations.removeValue(forKey: indexPath)
        }
    }
}

