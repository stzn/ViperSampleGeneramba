import UIKit
import RxSwift
import RxCocoa
import RxFeedback

final class QiitaItemsListViewController: UIViewController {
    
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public properties -
    
    var presenter: QiitaItemsListPresenterInterface!
    
    // MARK: - Private properties -
    
    private var cellHeightList: [IndexPath: CGFloat] = [:]
    private var imageLoadQueue = OperationQueue()
    private var imageLoadOperations = [IndexPath: ImageLoadOperation]()
    private var searchController = UISearchController(searchResultsController: nil)
    
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
        _setTableView()
    }
    
    private typealias State = QiitaItemsListPresenter.State
    private typealias Event = QiitaItemsListPresenter.Event
    
    private func _setupUI() {
        
        navigationItem.title = "List"
        
        definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        
        
        let triggerLoadNextPage: (Driver<State>)  -> Signal<Event> = { state in
            return state.flatMapLatest { [weak self] state -> Signal<Event> in
                
                guard let `self` = self else { return Signal.empty() }
                
                if state.shouldLoadNext || state.error != nil {
                    return Signal.empty()
                }
                return self.tableView.rx.reachBottom.map { _ in Event.startLoadingNextPage }
            }
        }
        
        let bindUI: (Driver<State>) -> Signal<Event> = bind(self) { me, state in
            
            let subscriptions = [
                state.map { $0.searchText }.drive(me.searchController.searchBar.rx.text),
                state.filter{ $0.error != nil }.map{ $0.error }
                    .drive(onNext: { error in
                        me.showErrorAlert(with: error!.localizedDescription) { _ in
                            me.hideLoading()
                            me.refreshControl.endRefreshing()
                        }
                    }),
                state.map { $0.contents }.drive(me.tableView.rx.items(cellIdentifier: QiitaItemTableViewCell.reuseIdentifier, cellType: QiitaItemTableViewCell.self))(me.configureCell)
            ]
            
            let events: [Signal<Event>] = [
                me.searchController.searchBar.rx.text.orEmpty.changed.asSignal().map(Event.searchChanged),
                me.searchController.searchBar.rx.cancelButtonClicked.asSignal().map(Event.searchReset),
                me.refreshControl.rx.controlEvent(.valueChanged).asSignal().map(Event.refreshing),
                triggerLoadNextPage(state)
            ]
            return Bindings(subscriptions: subscriptions, events: events)
        }
        
        Driver.system(
            initialState: State.empty,
            reduce: State.reduce,
            feedback:
            bindUI,
            react(query: { $0.loadNextPage }, effects: { [weak self] (text, nextPage) in
                
                guard let `self` = self else { return Signal.empty() }
                
                if !self.refreshControl.isRefreshing {
                    self.showLoading()
                }
                
                return self.presenter
                    .fetchList(text: text, nextPage: nextPage)
                    .asSignal(onErrorJustReturn: .error(NetworkError.offline))
                    .do(onNext: { [weak self] _ in
                        self?.hideLoading()
                        self?.refreshControl.endRefreshing()
                    })
                    .map(Event.response)
                
            })
            )
            .drive()
            .disposed(by: disposeBag)
        
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
        
        tableView.rx.modelSelected(QiitaItem.self).asDriver()
            .drive(onNext: { [weak self] item in
                
                guard let `self` = self else { return }
                
                self.presenter.modelSelected(item: item)
            })
            .disposed(by: disposeBag)
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    private func configureCell(_ row: Int, item: QiitaItem, cell: QiitaItemTableViewCell) {
        
        let indexPath = IndexPath(row: row, section: 0)
        
        cell.configure(item: item)
        
        if let imageLoadOperation = self.imageLoadOperations[indexPath],
            let image = imageLoadOperation.image {
            cell.profileImageView.setRoundedImage(image)
        } else {
            guard let url = item.user?.profile_image_url else {
                return
            }
            let imageLoadOperation = ImageLoadOperation(url: url)
            imageLoadOperation.completionHandler = { [weak self] image in
                guard let strongSelf = self else {
                    return
                }
                cell.profileImageView.setRoundedImage(image)
                strongSelf.imageLoadOperations.removeValue(forKey: indexPath)
            }
            self.imageLoadQueue.addOperation(imageLoadOperation)
            self.imageLoadOperations[indexPath] = imageLoadOperation
        }
    }
}

// MARK: - Extensions -

extension QiitaItemsListViewController: QiitaItemsListViewInterface {
    
    func scrolltoTop() {
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        guard let _ = tableView.cellForRow(at: indexPath) else {
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
            guard let cell = tableView.cellForRow(at: indexPath) as? QiitaItemTableViewCell,
                let url = cell.item?.user?.profile_image_url else {
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

