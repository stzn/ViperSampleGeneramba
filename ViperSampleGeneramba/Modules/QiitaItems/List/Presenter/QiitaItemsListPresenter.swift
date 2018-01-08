import UIKit

final class QiitaItemsListPresenter {

    // MARK: - Private properties -
    
    private weak var _view: QiitaItemsListViewInterface?
    private var _interactor: QiitaItemsListInteractorInterface
    private var _wireframe: QiitaItemsListWireframeInterface

    private var _trigger: TriggerType = TriggerType.refresh
    private var _state: NetworkState = NetworkState.nothing
    private var nextPage: Int = 1
    
    var canLoad: Bool {
        let loadingState: [NetworkState] = [.requesting, .reachedBottom]
        return !loadingState.contains(_state)
    }
    
    private var contents: [QiitaItem] = [] {
        didSet {
            if contents.count > 0 {
                _view?.showQiitaItemsList()
            } else {
                if _state != .requesting {
                    _view?.showNoContentScreen()
                }
            }
        }
    }

    // MARK: - Lifecycle -

    init(wireframe: QiitaItemsListWireframeInterface, view: QiitaItemsListViewInterface, interactor: QiitaItemsListInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }
}

// MARK: - Extensions -

extension QiitaItemsListPresenter: QiitaItemsListPresenterInterface {

    func viewDidLoad() {
        
        if !canLoad { return }
        
        _state = .requesting
        _trigger = .refresh
        _interactor.fetchList(query: "", page: 1)
        _view?.showLoading()
    }
    
    func searchBarTextDidChange(text: String) {
        
        if !canLoad { return }
        
        _state = .requesting
        _trigger = .searchTextChange
        nextPage = 1
        contents = []
        _interactor.fetchList(query: text, page: nextPage)
        _view?.showLoading()
    }
    
    func loadMore(searchText text: String) {
        
        if !canLoad { return }
        
        _state = .requesting
        _trigger = .loadMore
        _interactor.fetchList(query: text, page: nextPage)
        _view?.showLoading()
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        
        guard contents.count > indexPath.row else { return }
        
        let item = contents[indexPath.row]
        _wireframe.showDetail(item: item)
    }
    
    func numberOfRows() -> Int {
        return contents.count
    }
    
    func itemAt(_ indexPath: IndexPath) -> QiitaItem? {
        
        guard contents.count > indexPath.row else { return nil }
        
        return contents[indexPath.row]
    }
}

extension QiitaItemsListPresenter: QiitaItemsListInteractorOutputInterface {
    func fetchedList(items: [QiitaItem]) {
        
        _state = .nothing
        _view?.hideLoading()
        contents += items
        nextPage += 1
        
        if contents.count != 0 && items.count == 0 {
            _state = .reachedBottom
        }
        
        if _trigger == .searchTextChange {
            _view?.scrolltoTop()
        }
    }
    
    func fetchedListError(error: Error) {
        _state = .nothing
        contents = []
        nextPage = 1
        _view?.hideWithError(message: error.localizedDescription)
    }
}

