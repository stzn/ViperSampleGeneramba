import UIKit

final class AccountWireframe: AccountWireframeInterface, Step {

    // MARK: - public properties -
    let navigation: UINavigationController!
    var completion: ((AccountInformation?) -> Void)?
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    // MARK: - Private properties -
    
    // MARK: - Module setup -
    
    func perform(_ input: Void, completion: @escaping (AccountInformation?) -> Void) {
        
        let viewController = AccountViewController.fromStoryboard()
        let interactor = AccountInteractor()
        let presenter = AccountPresenter(wireframe: self, view: viewController, interactor: interactor)
        viewController.presenter = presenter
        interactor.output = presenter

        self.completion = completion
        
        navigation.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Transitions -
    
    // Go To Next Step
    func goToNextStep(_ output: AccountInformation?) {
        self.completion?(output)
    }
    
    func back() {
        self.completion?(nil)
    }
}
