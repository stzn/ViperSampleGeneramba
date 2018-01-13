import UIKit
import RxCocoa
import RxSwift

protocol QiitaItemsListWireframeInterface: WireframeInterface {
    func configureModule() -> UIViewController
    func showDetail(item: QiitaItem)
}

protocol QiitaItemsListViewInterface: ViewInterface {
    func scrolltoTop()
}

protocol QiitaItemsListPresenterInterface: PresenterInterface {
    
    typealias Input = (
        searchBarText: Driver<String>,
        didItemSelect: Driver<QiitaItem>,
        didReachBottom: Signal<Void>,
        searchBarCancelTap: Signal<Void>,
        refreshDidChange: Signal<Void>
    )
    
    var didItemsChange: Driver<[QiitaItem]> { get }
    var didStateChange: Signal<QiitaItemsListPresenter.State> { get }
    var didErrorChange: Signal<Error> { get }

    func numberOfRows() -> Int
    func itemAt(_ indexPath: IndexPath) ->QiitaItem?
    func bind(input: Input)
}

protocol QiitaItemsListInteractorInterface: InteractorInterface {
    func fetchList(query: String, page: Int) -> Single<Result<[QiitaItem]>>
}

protocol QiitaItemsListInteractorOutputInterface: InteractorOutputInterface {
}
