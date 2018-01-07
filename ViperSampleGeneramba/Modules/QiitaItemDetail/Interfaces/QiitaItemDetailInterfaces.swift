import UIKit

protocol QiitaItemDetailWireframeInterface: WireframeInterface {
    func configureModule(url: URL) -> UIViewController
}

protocol QiitaItemDetailViewInterface: ViewInterface {
    func showWebView(url: URL)
}

protocol QiitaItemDetailPresenterInterface: PresenterInterface {
}

protocol QiitaItemDetailInteractorInterface: InteractorInterface {
}

protocol QiitaItemDetailInteractorOutputInterface: InteractorOutputInterface {
}
