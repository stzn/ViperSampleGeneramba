import UIKit

protocol SplashWireframeInterface: WireframeInterface {
    func configureModule() -> UIViewController
    func showLoginScreenAsRoot()
    func showMainScreenAsRoot()
}

protocol SplashViewInterface: ViewInterface {
}

protocol SplashPresenterInterface: PresenterInterface {
    func viewDidLoad()
}

protocol SplashInteractorInterface: InteractorInterface {
    func fetchUserInfo()
}

protocol SplashInteractorOutputInterface: InteractorOutputInterface {
    func fetchedUserInfo(_ userInfo: UserInfo?)
}
