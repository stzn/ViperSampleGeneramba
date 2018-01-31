import UIKit

final class SampleImageSelectWireframe: SampleImageSelectWireframeInterface, Step {

    // MARK: - Private properties -
    let navigation: UINavigationController
    var completion: ((UIImage?) -> Void)?

    init(navigation: UINavigationController) {
        self.navigation = navigation
    }

    // MARK: - Module setup -

    func perform(_ input: Void, completion: @escaping (UIImage?) -> Void) {
        let viewController = SampleImageSelectViewController.fromStoryboard() 
        let interactor = SampleImageSelectInteractor()
        let presenter = SampleImageSelectPresenter(wireframe: self, view: viewController, interactor: interactor)
        viewController.presenter = presenter
        interactor.output = presenter
        
        self.completion = completion
        navigation.pushViewController(viewController, animated: true)
    }

    // MARK: - Transitions -
    func goToNextStep(_ output: UIImage?) {
        self.completion?(output)
    }
    
    func back() {
        self.completion?(nil)
    }

}
