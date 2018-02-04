import UIKit

protocol QiitaItemsListViewControllerDelegate: class {
    func showDetail(_ controller: QiitaItemsListViewController, item: QiitaItem)
}

final class QiitaItemsListViewController: UIViewController {

    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public properties -

    var presenter: QiitaItemsListPresenterInterface!
    weak var delegate: QiitaItemsListViewControllerDelegate?

    // MARK: - Private properties -
    private var reachedBottom : Bool = false
    private var cellHeightList: [IndexPath: CGFloat] = [:]
    private var imageLoadQueue = OperationQueue()
    private var imageLoadOperations = [IndexPath: ImageLoadOperation]()
    private var searchController = UISearchController(searchResultsController: nil)
    private var searchText: String = ""
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle -

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        _setupUI()
        presenter.viewDidLoad()
    }
    
    private func _setupUI() {
        
        navigationItem.title = "List"
        
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.delegate = self
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        setTableView()
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    private func setTableView() {
        
        tableView.register(QiitaItemTableViewCell.self)
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for:.valueChanged)
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    
        if #available(iOS 10.0, *) {
            tableView.prefetchDataSource = self
        }
    }
    
}

// MARK: - Extensions -

extension QiitaItemsListViewController {
    
    @objc func refresh(sender: UIRefreshControl) {
        
        let text = searchController.searchBar.text ?? ""
        presenter.refresh(searchText: text)
    }
}

extension QiitaItemsListViewController: QiitaItemsListViewInterface {
    
    func showNoContentScreen() {
        
        self.noResultLabel.text = "データが存在しません。"
        self.noResultLabel.isHidden = false
        self.tableView.isHidden = true
        hideLoading()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func showQiitaItemsList() {
        
        self.noResultLabel.isHidden = true
        self.tableView.isHidden = false
        hideLoading()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func showDetail(item: QiitaItem) {
        delegate?.showDetail(self, item: item)
    }
    
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
        return Storyboard.QiitaItemsListViewController.name
    }
}

extension QiitaItemsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: QiitaItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        guard let item = presenter.itemAt(indexPath) else {
            return UITableViewCell()
        }
        cell.configure(item: item)
        
        if let imageLoadOperation = imageLoadOperations[indexPath],
            let image = imageLoadOperation.image {
            cell.profileImageView.setRoundedImage(image)
        } else {
            guard let url = item.user?.profile_image_url else {
                return cell
            }
            let imageLoadOperation = ImageLoadOperation(url: url)
            imageLoadOperation.completionHandler = { [weak self] image in
                guard let strongSelf = self else {
                    return
                }
                cell.profileImageView.setRoundedImage(image)
                strongSelf.imageLoadOperations.removeValue(forKey: indexPath)
            }
            imageLoadQueue.addOperation(imageLoadOperation)
            imageLoadOperations[indexPath] = imageLoadOperation
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let imageLoadOperation = imageLoadOperations[indexPath] else {
            return
        }
        imageLoadOperation.cancel()
        imageLoadOperations.removeValue(forKey: indexPath)
    }
}

extension QiitaItemsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        presenter.didSelectRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !cellHeightList.keys.contains(indexPath) {
            cellHeightList[indexPath] = cell.frame.size.height
        }

        let isLastCell = (presenter.numberOfRows() - 1 == indexPath.row)
        
        if isLastCell {
            let text = searchController.searchBar.text ?? ""
            presenter.loadMore(searchText: text)
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

extension QiitaItemsListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchBarTextDidChange(text: "")
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

// MARK: - UISearchResultsUpdating
extension QiitaItemsListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchBarTextDidChange(_:)), object: searchController.searchBar)

        perform(#selector(self.searchBarTextDidChange(_:)), with: searchController.searchBar, afterDelay: 0.75)
    }


    @objc func searchBarTextDidChange(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text,
            !text.isEmpty, searchText != text else { return }
        
        searchText = text
        presenter.searchBarTextDidChange(text: text)
    }
}

