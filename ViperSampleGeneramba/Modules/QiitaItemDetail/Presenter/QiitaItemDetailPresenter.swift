import UIKit

final class QiitaItemDetailPresenter {

    // MARK: - Public properties -

    private weak var _view: QiitaItemDetailViewInterface?
    private var _interactor: QiitaItemDetailInteractorInterface
    private var _wireframe: QiitaItemDetailWireframeInterface
    private let _url: URL

    // MARK: - Lifecycle -

    init(wireframe: QiitaItemDetailWireframeInterface, view: QiitaItemDetailViewInterface, interactor: QiitaItemDetailInteractorInterface, url: URL) {
        _wireframe = wireframe
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

