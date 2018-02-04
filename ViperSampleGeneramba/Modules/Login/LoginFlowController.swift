import UIKit

protocol LoginFlowControllerDelegate: class {
    func loginFlowControllerDidFinish(_ flowController: LoginFlowController)
}


struct LoginDependencyContainer {
    
}

final class LoginFlowController: UIViewController {
    
    private let dependencyContainer: LoginDependencyContainer
    private var embeddedNavigationController: UINavigationController!
    weak var delegate: LoginFlowControllerDelegate?
    
    init(dependencyContainer: LoginDependencyContainer) {
        
        self.dependencyContainer = dependencyContainer
        super.init(nibName: nil, bundle: nil)
        
        embeddedNavigationController = UINavigationController()
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
        
        let viewController = LoginViewController.fromStoryboard()
        let interactor = LoginInteractor()
        let presenter = LoginPresenter(view: viewController, interactor: interactor)
        viewController.presenter = presenter
        interactor.output = presenter
        
        viewController.delegate = self
        
        embeddedNavigationController.viewControllers = [viewController]
    }
}

// MARK: - Extensions -

extension LoginFlowController: LoginViewControllerDelegate {
    func didLogin(_ controller: LoginViewController) {
        delegate?.loginFlowControllerDidFinish(self)
    }
}

