import Foundation
import RxSwift

final class LoginInteractor {
    weak var output: LoginInteractorOutputInterface?
}

// MARK: - Extensions -

extension LoginInteractor: LoginInteractorInterface {

    func saveUserInfo(_ userInfo: UserInfo) -> Single<Result<Bool, Error>> {
        return Single.create(subscribe: { observer in
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.loggedIn)
            observer(.success(Result.success(true)))
            return Disposables.create()
        })
    }
    
    func login(id: String, password: String) -> Single<Result<Bool, Error>>{
        return Single.create(subscribe: { observer in
            observer(.success(Result.success(true)))
            return Disposables.create()
        })
    }
}
