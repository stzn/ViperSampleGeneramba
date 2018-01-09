import UIKit


final class QiitaItemsListPresenter {

    struct State: Equatable {
        
        let trigger: TriggerType
        let state: NetworkState
        let nextPage: Int
        let contents: [QiitaItem]
        
        init(trigger: TriggerType = .refresh,
             state: NetworkState = .nothing,
             nextPage: Int = 1,
             contents: [QiitaItem] = []) {
            
            self.trigger = trigger
            self.state = state
            self.nextPage = nextPage
            self.contents = contents
        }
        
        var canLoad: Bool {
            let loadingState: [NetworkState] = [.requesting, .reachedBottom]
            return !loadingState.contains(state)
        }
        
        static func ==(lhs: QiitaItemsListPresenter.State, rhs: QiitaItemsListPresenter.State) -> Bool {
            return lhs.state == rhs.state
                && lhs.nextPage == rhs.nextPage
                && lhs.trigger == rhs.trigger
                && lhs.contents == rhs.contents
        }
        
        static let initial = State()
    }
    
    
    
    // MARK: - Private properties -
    
    private var state: State = State.initial {
        didSet {
            if oldValue == state {
                return
            }
            
            if state.trigger != .refresh
                && oldValue.contents == state.contents {
                return
            }
            
            if state.contents.count > 0 {
                _view?.showQiitaItemsList()
            } else {
                if state.state != .requesting {
                    _view?.showNoContentScreen()
                }
            }
        }
    }
    
    private weak var _view: QiitaItemsListViewInterface?
    private var _interactor: QiitaItemsListInteractorInterface
    private var _wireframe: QiitaItemsListWireframeInterface

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
        
        if !state.canLoad { return }
        
        
        state = State(trigger: .refresh, state: .requesting)
        _interactor.fetchList(query: "", page: 1)
        _view?.showLoading()
    }
    
    func searchBarTextDidChange(text: String) {
        
        if !state.canLoad { return }
        
        
        state = State.init(trigger: .searchTextChange,
                           state: .requesting,
                           nextPage: 1,
                           contents: [])
        _interactor.fetchList(query: text, page: state.nextPage)
        _view?.showLoading()
    }
    
    func loadMore(searchText text: String) {
        
        if !state.canLoad { return }
        
        state = State.init(trigger: .loadMore,
                           state: .requesting,
                           nextPage: state.nextPage,
                           contents: state.contents)
        _interactor.fetchList(query: text, page: state.nextPage)
        _view?.showLoading()
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        
        guard state.contents.count > indexPath.row else { return }
        
        let item = state.contents[indexPath.row]
        _wireframe.showDetail(item: item)
    }
    
    func numberOfRows() -> Int {
        return state.contents.count
    }
    
    func itemAt(_ indexPath: IndexPath) -> QiitaItem? {
        
        guard state.contents.count > indexPath.row else { return nil }
        
        return state.contents[indexPath.row]
    }
}

extension QiitaItemsListPresenter: QiitaItemsListInteractorOutputInterface {
    func fetchedList(items: [QiitaItem]) {
        
        var networkState: NetworkState = .nothing
        _view?.hideLoading()
        
        if items.count == 0 {
            networkState = .reachedBottom
        }
        
        state = State.init(trigger: state.trigger,
                           state: networkState,
                           nextPage: state.nextPage + 1,
                           contents: state.contents + items)

        if state.trigger == .searchTextChange {
            _view?.scrolltoTop()
        }
        
    }
    
    func fetchedListError(error: Error) {

        state = State.init(trigger: state.trigger,
                           state: .nothing,
                           nextPage: 1,
                           contents: [])
        _view?.hideWithError(message: error.localizedDescription)
    }
}

