import UIKit
import RxSwift
import RxCocoa

final class QiitaItemsListPresenter {
    
    struct State: Equatable {
        let trigger: TriggerType
        let state: NetworkState
        let nextPage: Int
        fileprivate(set) var shouldLoadNext: Bool
        let contents: [QiitaItem]
        let error: Error?

        var canLoad: Bool {
            let loadingState: [NetworkState] = [.requesting, .reachedBottom]
            return !loadingState.contains(state)
        }
        
        static func ==(lhs: QiitaItemsListPresenter.State, rhs: QiitaItemsListPresenter.State) -> Bool {
            return lhs.trigger == rhs.trigger
                && lhs.state == rhs.state
                && lhs.nextPage == rhs.nextPage
                && lhs.shouldLoadNext == rhs.shouldLoadNext
                && lhs.contents == rhs.contents
        }
        
        static var initial = State(
            trigger: .refresh,
            state: .nothing,
            nextPage: 1,
            shouldLoadNext: true,
            contents: [],
            error: nil
        )
    }
    
    // MARK: - Public properties -
    
    let didItemsChange: Driver<[QiitaItem]>
    let didStateChange: Signal<State>
    let didErrorChange: Signal<Error>
    
    // MARK: - Private properties -
    
    private let didItemsChangeRelay: BehaviorRelay<[QiitaItem]>
    private let didStateChangeRelay: PublishRelay<State>
    private let didErrorChangeRelay: PublishRelay<Error>
    
    private weak var _view: QiitaItemsListViewInterface?
    private var _interactor: QiitaItemsListInteractorInterface
    private var _wireframe: QiitaItemsListWireframeInterface
    private let disposeBag = DisposeBag()
    
    private var state: State = State.initial {
        didSet {
            if state == oldValue {
                return
            }
            state.shouldLoadNext = (state.nextPage != oldValue.nextPage)
            
            if state.contents != oldValue.contents {
                didItemsChangeRelay.accept(state.contents)
            }
            
            if state.error != nil {
                didErrorChangeRelay.accept(state.error!)
            }
            didStateChangeRelay.accept(state)
        }
    }
    
    // MARK: - Lifecycle -
    
    init(wireframe: QiitaItemsListWireframeInterface, view: QiitaItemsListViewInterface, interactor: QiitaItemsListInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
        
        let didStateChangeRelay = PublishRelay<State>()
        self.didStateChangeRelay = didStateChangeRelay
        self.didStateChange = didStateChangeRelay.asSignal()

        let didItemsChangeRelay = BehaviorRelay<[QiitaItem]>(value: [])
        self.didItemsChangeRelay = didItemsChangeRelay
        self.didItemsChange = didItemsChangeRelay.asDriver()
        
        let didErrorChangeRelay = PublishRelay<Error>()
        self.didErrorChangeRelay = didErrorChangeRelay
        self.didErrorChange = didErrorChangeRelay.asSignal()
    }
}

// MARK: - Extensions -

extension QiitaItemsListPresenter: QiitaItemsListPresenterInterface {
    
    func bind(input: Input) {
        
        input.searchBarText.drive(onNext: { [weak self] text in
            
            guard let `self` = self else { return }
            
            if !self.state.canLoad { return }
            
            self.fetchFirstPage(trigger: .searchTextChange, text: text)
        })
        .disposed(by: disposeBag)
        
        input.didReachBottom
            .withLatestFrom(input.searchBarText)
            .emit(onNext: { [weak self] text in
                
                guard let `self` = self else { return }
                
                if !self.state.canLoad || !self.state.shouldLoadNext { return }
                
                self.state = State(trigger: .loadMore,
                              state: .requesting,
                              nextPage: self.state.nextPage,
                              shouldLoadNext: false,
                              contents: self.state.contents,
                              error: nil
                )
                
                self.fetchList(text: text)
            })
            .disposed(by: disposeBag)
        
        input.didItemSelect.drive(onNext: { [weak self] item in
            
            guard let `self` = self else { return }
            
            self._wireframe.showDetail(item: item)
        })
        .disposed(by: disposeBag)
        
        input.searchBarCancelTap.emit(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            
            self.fetchFirstPage(trigger: .searchTextChange)
        })
        .disposed(by: disposeBag)
        
        input.refreshDidChange
            .withLatestFrom(input.searchBarText)
            .emit(onNext: { [weak self] text in
            
            guard let `self` = self else { return }
            
            self.fetchFirstPage(trigger: .refresh, text: text)
        })
        .disposed(by: disposeBag)
        
    }
    
    func numberOfRows() -> Int {
        return state.contents.count
    }
    
    func itemAt(_ indexPath: IndexPath) -> QiitaItem? {
        
        guard state.contents.count > indexPath.row else { return nil }
        
        return state.contents[indexPath.row]
    }
    
    private func fetchFirstPage(trigger: TriggerType, text: String? = nil) {
        
        state = State(trigger: trigger,
                           state: .requesting,
                           nextPage: 1,
                           shouldLoadNext: true,
                           contents: [],
                           error: nil
        )
        
        fetchList(text: text ?? "")
    }
    
    private func fetchList(text: String) {
        
        _view?.showLoading()
        
        _interactor
            .fetchList(query: text, page: state.nextPage)
            .subscribeOn(MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] result in
                    
                    guard let `self` = self else { return }
                    
                    switch result {
                    case let .success(items):
                        self.fetchedList(items: items)
                    case let .error(error):
                        self.fetchedListError(error: error)
                    }
                },
                onError: { error in
                    self.fetchedListError(error: error)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchedList(items: [QiitaItem]) {
        
        var newtWorkState: NetworkState
        if state.contents.count != 0 && items.count == 0 {
            newtWorkState = .reachedBottom
        } else {
            newtWorkState = .requestFinished
        }
        
        state = State(trigger: state.trigger,
                      state: newtWorkState,
                      nextPage: state.nextPage + 1,
                      shouldLoadNext: state.shouldLoadNext,
                      contents: state.contents + items,
                      error: nil
        )
    }
    
    private func fetchedListError(error: Error) {
        
        state = State(trigger: state.trigger,
                      state: .nothing,
                      nextPage: 1,
                      shouldLoadNext: true,
                      contents: [],
                      error: error
        )
    }
}

extension QiitaItemsListPresenter: QiitaItemsListInteractorOutputInterface {
}

