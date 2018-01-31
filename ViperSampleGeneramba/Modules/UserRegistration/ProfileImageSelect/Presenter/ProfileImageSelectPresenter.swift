import UIKit

final class ProfileImageSelectPresenter {

    // MARK: - Private properties -

    fileprivate weak var _view: ProfileImageSelectViewInterface?
    fileprivate var _interactor: ProfileImageSelectInteractorInterface
    fileprivate var _wireframe: ProfileImageSelectWireframeInterface

    // MARK: - Lifecycle -

    init(wireframe: ProfileImageSelectWireframeInterface, view: ProfileImageSelectViewInterface, interactor: ProfileImageSelectInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }
}

// MARK: - Extensions -

extension ProfileImageSelectPresenter: ProfileImageSelectPresenterInterface {
    
    func selectSampleButtonTapped() {
        _wireframe.goToNextStep(.sample)
    }
    
    func confirmButtonTapped(image: UIImage) {
        _wireframe.goToNextStep(.own(image))
    }
    
    func backButtonTapped() {
        _wireframe.back()
    }
    
}

extension ProfileImageSelectPresenter: ProfileImageSelectInteractorOutputInterface {
}

