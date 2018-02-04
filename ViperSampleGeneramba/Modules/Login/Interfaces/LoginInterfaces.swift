import UIKit

protocol LoginViewInterface: ViewInterface {
    func didLogin()
}

protocol LoginPresenterInterface: PresenterInterface {
    func loginButtonTapped(id: String?, password: String?)
}

protocol LoginInteractorInterface: InteractorInterface {
    func login(id: String, password: String)
    func saveUserInfo(_ userInfo: UserInfo)
}

protocol LoginInteractorOutputInterface: InteractorOutputInterface {
    func loginSuceeded()
    func loginFailed()
    func userInfoSaveSucceeded()
    func userInfoSaveFailed()
}

