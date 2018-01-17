import UIKit
import RxSwift
import RxCocoa
import RxFeedback

final class QiitaItemsListPresenter {
    
    
    struct State {
        
        var searchText: String {
            didSet {
                if searchText.isEmpty {
                    nextPage = 1
                    shouldLoadNext = false
                    contents = []
                    error = nil
                    return
                }
                shouldLoadNext = true
                error = nil
            }
        }
        
        var nextPage: Int = 1
        var shouldLoadNext: Bool = true
        var contents: [QiitaItem]
        var error: Error? = nil
        
        static var empty: State {
            return State(searchText: "", nextPage: 1, shouldLoadNext: true, contents: [], error: nil)
        }
        
        var loadNextPage: (searchText: String, nextPage: Int)? {
            return shouldLoadNext ? (searchText, nextPage) : nil
        }
        
        static func reduce(state: State, event: Event) -> State {
            switch event {
            case .searchChanged(let searchText):
                var result = state
                result.searchText = searchText
                result.contents = []
                result.nextPage = 1
                return result
            case .response(.success(let response)):
                var result = state
                result.contents += response
                
                if !response.isEmpty {
                    result.nextPage += 1
                    result.error = nil
                } else {
                    result.error = NetworkError.noData
                }
                
                result.shouldLoadNext = false
                return result
            case .response(.error(let error)):
                var result = state
                result.shouldLoadNext = false
                result.error = error
                return result
            case .startLoadingNextPage:
                var result = state
                result.shouldLoadNext = true
                return result
            case .refreshing:
                var result = state
                result.shouldLoadNext = false
                result.contents = []
                result.nextPage = 1
                result.error = nil
                return result
            case .searchReset:
                var result = state
                result.searchText = ""
                return result
            }
        }
    }
    
    enum Event {
        case searchChanged(String)
        case response(QiitaItemsResponse)
        case startLoadingNextPage
        case refreshing(Any)
        case searchReset(Any)
    }
    
    typealias QiitaItemsResponse = Result<[QiitaItem]>

    
    // MARK: - Public properties -
    
    // MARK: - Private properties -
    
    private weak var _view: QiitaItemsListViewInterface?
    private var _interactor: QiitaItemsListInteractorInterface
    private var _wireframe: QiitaItemsListWireframeInterface
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Lifecycle -
    
    init(wireframe: QiitaItemsListWireframeInterface, view: QiitaItemsListViewInterface, interactor: QiitaItemsListInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }
}

// MARK: - Extensions -

extension QiitaItemsListPresenter: QiitaItemsListPresenterInterface {
    
    func fetchList(text: String, nextPage: Int) -> Single<QiitaItemsResponse> {
        
        return _interactor.fetchList(query: text, page: nextPage)
    }
    
    func modelSelected(item: QiitaItem) {
        _wireframe.showDetail(item: item)
    }
}

extension QiitaItemsListPresenter: QiitaItemsListInteractorOutputInterface {
}

