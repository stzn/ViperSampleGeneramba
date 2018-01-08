import UIKit

final class LoginPresenter {
    
    // MARK: - Public properties -
    
    private weak var _view: LoginViewInterface?
    private var _interactor: LoginInteractorInterface
    private var _wireframe: LoginWireframeInterface
    
    // MARK: - Lifecycle -
    
    init(wireframe: LoginWireframeInterface, view: LoginViewInterface, interactor: LoginInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }
}

// MARK: - Extensions -

extension LoginPresenter: LoginPresenterInterface {
    
    func loginButtonTapped(id: String, password: String) {
        
        guard !id.isEmpty && !password.isEmpty else {
            showLoginError()
            return
        }
        
        _view?.showLoading()
        _interactor.login(id: id, password: password)
    }
    
    private func showLoginError() {
        _view?.showAlert(title: "エラー", message: "ログインIDとパスワードは必ず入力してください。")
    }
    
    private func showIdValidationError() {
        _view?.showAlert(title: "エラー", message: "IDは英数字8文字以上で入力してください。")
    }
    
    private func showPasswordValidationError() {
        _view?.showAlert(title: "エラー", message: "パスワードは英数字8文字以上で入力してください。")
    }
}

extension LoginPresenter: LoginInteractorOutputInterface {
    func loginSuceeded() {
        let userInfo = UserInfo(name: "Dummy")
        _interactor.saveUserInfo(userInfo)
    }
    
    func loginFailed() {
        _view?.hideLoading()
        _view?.showErrorAlert(message: "ログインIDまたはパスワードが間違っています。")
    }
    
    func userInfoSaveSucceeded() {
        _view?.hideLoading()
        _wireframe.showMainScreen()
    }
    
    func userInfoSaveFailed() {
        _view?.hideLoading()
        _view?.showErrorAlert(message: "ログインIDまたはパスワードが間違っています。")
    }
}
