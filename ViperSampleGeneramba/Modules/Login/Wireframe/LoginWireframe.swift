import UIKit

final class LoginWireframe: LoginWireframeInterface {

    // MARK: - Private properties -
    private var _navigationController: UINavigationController!
    
    // MARK: - Module setup -    
    func configureModule() -> UIViewController {
        
        let viewController = LoginViewController.fromStoryboard()
        let interactor = LoginInteractor()
        let presenter = LoginPresenter(wireframe: self, view: viewController, interactor: interactor)
        viewController.presenter = presenter
        interactor.output = presenter
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        _navigationController = navigationController
        
        return navigationController
    }

    // MARK: - Transitions -
    
    func showMainScreen() {        
        let root = AppDelegate.shared.rootViewCotnroller
        root.showMainScreen()
    }
    
    func startUserRegistration() {
        let root = AppDelegate.shared.rootViewCotnroller
        root.showRegiatrationScreen()
    }
}
