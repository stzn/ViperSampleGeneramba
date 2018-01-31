import UIKit

protocol LoginWireframeInterface: WireframeInterface {
    func configureModule() -> UIViewController
    func showMainScreen()
    func startUserRegistration()
}

protocol LoginViewInterface: ViewInterface {
}

protocol LoginPresenterInterface: PresenterInterface {
    func loginButtonTapped(id: String, password: String)
    func userRegistrationButtonTapped()
}

protocol LoginInteractorInterface: InteractorInterface {
    func login(id: String , password: String)
    func saveUserInfo(_ userInfo: UserInfo)
}

protocol LoginInteractorOutputInterface: InteractorOutputInterface {
    func loginSuceeded()
    func loginFailed()
    func userInfoSaveSucceeded()
    func userInfoSaveFailed()
}

