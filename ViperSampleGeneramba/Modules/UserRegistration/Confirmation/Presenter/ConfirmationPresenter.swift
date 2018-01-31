import UIKit

final class ConfirmationPresenter {

    // MARK: - Public properties -
    var userRegistraton: UserRegistration {
        return _userRegistration
    }
    
    // MARK: - Private properties -
    private let _userRegistration: UserRegistration!

    fileprivate weak var _view: ConfirmationViewInterface?
    fileprivate var _interactor: ConfirmationInteractorInterface
    fileprivate var _wireframe: ConfirmationWireframeInterface

    // MARK: - Lifecycle -

    init(wireframe: ConfirmationWireframeInterface, view: ConfirmationViewInterface, interactor: ConfirmationInteractorInterface, input: UserRegistration) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
        _userRegistration = input
    }
}

// MARK: - Extensions -

extension ConfirmationPresenter: ConfirmationPresenterInterface {
    
    func registerButtonTapped() {
        _view?.showAlert(title: "完了", message: "登録が完了しました。",
                         actions: nil) { [unowned self] _ in
            self._wireframe.finish()
        }
    }
    
    func backButtonTapped() {
        _wireframe.back()
    }
}

extension ConfirmationPresenter: ConfirmationInteractorOutputInterface {
}

