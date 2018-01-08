import UIKit

final class QiitaItemsListWireframe: QiitaItemsListWireframeInterface {

    // MARK: - public properties -
    weak var viewController: CustomNavigationController!
    
    // MARK: - Module setup -

    func configureModule() -> UIViewController {
        
        let viewController = QiitaItemsListViewController.fromStoryboard()
        let interactor = QiitaItemsListInteractor()
        let presenter = QiitaItemsListPresenter(wireframe: self, view: viewController, interactor: interactor)
        viewController.presenter = presenter
        interactor.output = presenter
        
        let navigationController = CustomNavigationController(rootViewController: viewController)
        
        self.viewController = navigationController
        
        return navigationController
    }

    // MARK: - Transitions -
    func showDetail(item: QiitaItem) {
        let wireFrame = QiitaItemDetailWireframe()
        let new = wireFrame.configureModule(url: item.url)
        viewController.pushViewController(new, animated: true)
    }
}
