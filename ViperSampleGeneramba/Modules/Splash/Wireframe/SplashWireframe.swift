import UIKit

final class SplashWireframe: SplashWireframeInterface {
    
    // MARK: - Private properties -
    
    weak var viewController: SplashViewController!
    
    // MARK: - Module setup -
    func configureModule() -> UIViewController {

        let viewController = SplashViewController.fromStoryboard()
        let interactor = SplashInteractor()
        let presenter = SplashPresenter(wireframe: self, view: viewController, interactor: interactor)
        viewController.presenter = presenter
        interactor.output = presenter
        
        self.viewController = viewController
        
        return viewController
    }
    
    
    // MARK: - Transition -
    func showLoginScreenAsRoot() {
        let root = AppDelegate.shared.rootViewCotnroller
        root.showLoginScreen()
    }
    
    func showMainScreenAsRoot() {
        let root = AppDelegate.shared.rootViewCotnroller
        root.showMainScreen()
    }
}
