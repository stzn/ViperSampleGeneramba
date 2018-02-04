import UIKit

final class LoginPresenter {
    
    // MARK: - Public properties -
    
    // MARK: - Lifecycle -
    private weak var _view: LoginViewInterface?
    private var _interactor: LoginInteractorInterface

    init(view: LoginViewInterface, interactor: LoginInteractorInterface) {
        self._view = view
        self._interactor = interactor
    }
}

// MARK: - Extensions -

extension LoginPresenter: LoginPresenterInterface {
    
    func loginButtonTapped(id: String?, password: String?) {
        
        guard let id = id, let password = password,
            !id.isEmpty, !password.isEmpty else {
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
        let user = UserInfo(name: "ダミー")
        _interactor.saveUserInfo(user)
    }
    
    func loginFailed() {
        _view?.showAlert(title: "エラー", message: "ログインIDまたはパスワードが間違っています。")
    }
    
    func userInfoSaveSucceeded() {
        _view?.hideLoading()
        _view?.didLogin()
    }
    
    func userInfoSaveFailed() {
        _view?.showAlert(title: "エラー", message: "ログインに失敗しました。一定時間経過後に再度お試しください。")
    }
}
