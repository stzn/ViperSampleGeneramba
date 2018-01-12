import UIKit

final class QiitaItemDetailWireframe: QiitaItemDetailWireframeInterface {

    // MARK: - Private properties -

    // MARK: - Module setup -

    func configureModule(url: URL) -> UIViewController {
        let viewController = QiitaItemDetailViewController.fromStoryboard()
        let interactor = QiitaItemDetailInteractor()
        let presenter = QiitaItemDetailPresenter(wireframe: self, view: viewController, interactor: interactor, url: url)
        viewController.presenter = presenter
        interactor.output = presenter
        
        return viewController
    }

    // MARK: - Transitions -

}
