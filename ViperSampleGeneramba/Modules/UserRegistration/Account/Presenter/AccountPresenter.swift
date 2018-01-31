import UIKit

final class AccountPresenter {

    // MARK: - Private properties -

    fileprivate weak var _view: AccountViewInterface?
    fileprivate var _interactor: AccountInteractorInterface
    fileprivate var _wireframe: AccountWireframeInterface

    // MARK: - Lifecycle -

    init(wireframe: AccountWireframeInterface, view: AccountViewInterface, interactor: AccountInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }
}

// MARK: - Extensions -

extension AccountPresenter: AccountPresenterInterface {
    
    func confirmButtonTapped(nickName: String?, loginId: String?, password: String?) {
        
        guard let nickName = validNickName(nickName) else { return }
        
        guard let loginId = validLoginId(loginId) else { return }
        
        guard let password = validPassword(password) else { return }
        
        let login = Account(nickname: nickName, loginId: loginId, password: password)
        _wireframe.goToNextStep(login)
    }
    
    func backButtonTapped() {
        _wireframe.back()
    }
    
    private func validNickName(_ nickName: String?) -> String? {
        
        let columnName = "ニックネーム"
        
        guard let nickName = nickName else {
            showRequiredValidationError(columnName)
            return nil
        }
        return nickName
    }
    
    private func validLoginId(_ loginId: String?) -> String? {
        
        let columnName = "ログインID"
        
        guard let loginId = loginId else {
            showRequiredValidationError(columnName)
            return nil
        }
        return loginId
    }
    
    private func validPassword(_ password: String?) -> String? {
        
        let columnName = "パスワード"
        
        guard let password = password else {
            showRequiredValidationError(columnName)
            return nil
        }
        return password
    }
    
    private func showRequiredValidationError(_ columnName: String) {
        _view?.showAlert(title: "エラー", message: columnName + "は必ず入力してください。")
    }
}

extension AccountPresenter: AccountInteractorOutputInterface {
}

