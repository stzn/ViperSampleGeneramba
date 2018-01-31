import UIKit

final class ProfileImageSelectWireframe: ProfileImageSelectWireframeInterface, Step {

    // MARK: - public properties -
    let navigation: UINavigationController!
    var completion: ((ProfileImageType?) -> Void)?
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    

    // MARK: - Private properties -

    // MARK: - Module setup -

    func perform(_ input: Void, completion: @escaping (ProfileImageType?) -> Void) {

        let viewController = ProfileImageSelectViewController.fromStoryboard()
        let interactor = ProfileImageSelectInteractor()
        let presenter = ProfileImageSelectPresenter(wireframe: self, view: viewController, interactor: interactor)
        viewController.presenter = presenter
        interactor.output = presenter

        self.completion = completion
        
        navigation.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Transitions -
    
    // 次のステップへ遷移
    func goToNextStep(_ output: ProfileImageType?) {
        self.completion?(output)
    }
    
    func back() {
        self.completion?(nil)
    }
}
