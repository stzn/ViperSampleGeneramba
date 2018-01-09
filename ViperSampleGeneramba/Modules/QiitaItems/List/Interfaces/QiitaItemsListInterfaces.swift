import UIKit

protocol QiitaItemsListWireframeInterface: WireframeInterface {
    func configureModule() -> UIViewController
    func showDetail(item: QiitaItem)
}

protocol QiitaItemsListViewInterface: ViewInterface {
    func showNoContentScreen()
    func showQiitaItemsList()
    func scrolltoTop()
}

protocol QiitaItemsListPresenterInterface: PresenterInterface {
    func viewDidLoad()
    func refresh(searchText: String)
    func searchBarTextDidChange(text: String)
    func loadMore(searchText: String)
    func didSelectRowAt(_ indexPath: IndexPath)
    func numberOfRows() -> Int
    func itemAt(_ indexPath: IndexPath) ->QiitaItem?
}

protocol QiitaItemsListInteractorInterface: InteractorInterface {
    func fetchList(query: String, page: Int)
}

protocol QiitaItemsListInteractorOutputInterface: InteractorOutputInterface {
    func fetchedList(items: [QiitaItem])
    func fetchedListError(error: Error)
}
