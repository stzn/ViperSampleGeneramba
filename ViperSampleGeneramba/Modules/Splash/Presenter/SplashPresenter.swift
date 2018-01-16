import UIKit

final class SplashPresenter {
    
    // MARK: - Private properties -
    
    fileprivate weak var _view: SplashViewInterface?
    fileprivate var _interactor: SplashInteractorInterface
    fileprivate var _wireframe: SplashWireframeInterface
    
    // MARK: - Lifecycle -
    
    init(wireframe: SplashWireframeInterface, view: SplashViewInterface, interactor: SplashInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }
}

// MARK: - Extensions -

extension SplashPresenter: SplashPresenterInterface {
    
    func viewDidLoad() {
        
        _view?.showLoading()
        _interactor.fetchUserInfo()
    }
}

extension SplashPresenter: SplashInteractorOutputInterface {
    func fetchedUserInfo(_ userInfo: UserInfo?) {
        _view?.hideLoading()
        if let _ = userInfo {
            _wireframe.showMainScreenAsRoot()
        } else {
            _wireframe.showLoginScreenAsRoot()
        }
    }
}
