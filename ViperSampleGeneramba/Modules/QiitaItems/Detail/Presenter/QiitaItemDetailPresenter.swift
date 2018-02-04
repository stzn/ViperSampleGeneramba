import UIKit

final class QiitaItemDetailPresenter {

    // MARK: - Public properties -

    private weak var _view: QiitaItemDetailViewInterface?
    private var _interactor: QiitaItemDetailInteractorInterface
    private let _url: URL

    // MARK: - Lifecycle -

    init(view: QiitaItemDetailViewInterface, interactor: QiitaItemDetailInteractorInterface, url: URL) {
        _view = view
        _interactor = interactor
        _url = url
    }
}

// MARK: - Extensions -

extension QiitaItemDetailPresenter: QiitaItemDetailPresenterInterface {
    func viewDidLoad() {
        _view?.showWebView(url: _url)
    }
}

extension QiitaItemDetailPresenter: QiitaItemDetailInteractorOutputInterface {
}

