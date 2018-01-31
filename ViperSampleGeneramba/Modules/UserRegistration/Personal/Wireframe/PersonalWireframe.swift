import UIKit

final class PersonalWireframe: PersonalWireframeInterface, Step {

    // MARK: - public properties -
    let navigation: UINavigationController
    var completion: ((Personal?) -> Void)?

    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    // MARK: - Private properties -

    // MARK: - Module setup -

    func perform(_ input: Void, completion: @escaping (Personal?) -> Void) {

        let viewController = PersonalViewController.fromStoryboard()
        let interactor = PersonalInteractor()
        let presenter = PersonalPresenter(wireframe: self, view: viewController, interactor: interactor)
        viewController.presenter = presenter
        interactor.output = presenter
        
        self.completion = completion
        navigation.pushViewController(viewController, animated: true)
    }

    // MARK: - Transitions -
    
    // 次のステップへ遷移
    func goToNextStep(_ output: Personal?) {
        self.completion?(output)
    }
    
    func back() {
        self.completion?(nil)
    }
}
