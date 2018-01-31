import UIKit

final class ConfirmationWireframe: ConfirmationWireframeInterface, Step {

    // MARK: - public properties -
    let navigation: UINavigationController!
    var completion: ((Bool?) -> Void)?
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    // MARK: - Private properties -
    
    // MARK: - Module setup -
    
    func perform(_ input: UserRegistration, completion: @escaping (Bool?) -> Void) {
        
        let viewController = ConfirmationViewController.fromStoryboard()
        let interactor = ConfirmationInteractor()
        let presenter = ConfirmationPresenter(wireframe: self, view: viewController, interactor: interactor, input: input)
        viewController.presenter = presenter
        interactor.output = presenter
        
        self.completion = completion
        
        navigation.pushViewController(viewController, animated: true)
    }

    // MARK: - Transitions -
    func finish() {
        self.completion?(true)
    }
    
    func back() {
        self.completion?(nil)
    }
}
