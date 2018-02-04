import UIKit

protocol QiitaItemsListFlowControllerDelegate: class {
    func qiitaItemsListFlowControllerDidFinish(_ flowController: QiitaItemsListFlowController)
}

struct QiitaItemsDependencyContainer {
    
}

final class QiitaItemsListFlowController: UIViewController {
    
    private let dependencyContainer: QiitaItemsDependencyContainer
    private var embeddedNavigationController: CustomNavigationController!
    weak var delegate: QiitaItemsListFlowControllerDelegate?
    
    init(dependencyContainer: QiitaItemsDependencyContainer) {
 
        self.dependencyContainer = dependencyContainer
        super.init(nibName: nil, bundle: nil)
        
        embeddedNavigationController = CustomNavigationController()
        add(childController: embeddedNavigationController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        childViewControllers.first?.view.frame = view.bounds
    }
    
    func start() {
        
        let viewController = QiitaItemsListViewController.fromStoryboard()
        let interactor = QiitaItemsListInteractor()
        let presenter = QiitaItemsListPresenter(view: viewController, interactor: interactor)
        viewController.presenter = presenter
        interactor.output = presenter
        
        viewController.delegate = self
        
        embeddedNavigationController.viewControllers = [viewController]
    }
}

extension QiitaItemsListFlowController: QiitaItemsListViewControllerDelegate {
    
    func showDetail(_ controller: QiitaItemsListViewController, item: QiitaItem) {
        
        let viewController = QiitaItemDetailViewController.fromStoryboard()
        let interactor = QiitaItemDetailInteractor()
        let presenter = QiitaItemDetailPresenter(view: viewController, interactor: interactor, url: item.url)
        viewController.presenter = presenter
        interactor.output = presenter
        
        embeddedNavigationController.pushViewController(viewController, animated: true)
    }
}
