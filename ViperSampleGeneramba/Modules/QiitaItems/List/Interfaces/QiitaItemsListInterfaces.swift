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
    
    func fetchList(text: String, nextPage: Int) -> Single<QiitaItemsListPresenter.QiitaItemsResponse>
    func modelSelected(item: QiitaItem)
}

protocol QiitaItemsListInteractorInterface: InteractorInterface {
    func fetchList(query: String, page: Int) -> Single<Result<[QiitaItem], NetworkError>>
}

protocol QiitaItemsListInteractorOutputInterface: InteractorOutputInterface {
}
