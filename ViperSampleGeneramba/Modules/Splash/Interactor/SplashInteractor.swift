import Foundation

final class SplashInteractor {
    
    weak var output: SplashInteractorOutputInterface?
}

// MARK: - Extensions -

extension SplashInteractor: SplashInteractorInterface {
    
    func fetchUserInfo() {
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.loggedIn) {
            output?.fetchedUserInfo(UserInfo(name: "Dummy"))
        } else {
            output?.fetchedUserInfo(nil)
        }
    }
}


