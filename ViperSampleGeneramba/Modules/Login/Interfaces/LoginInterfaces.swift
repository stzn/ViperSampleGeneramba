import UIKit
import RxSwift
import RxCocoa

protocol LoginWireframeInterface: WireframeInterface {
    func configureModule() -> UIViewController
    func showMainScreen()
}

protocol LoginViewInterface: ViewInterface {
}

protocol LoginPresenterInterface: PresenterInterface {
    
    typealias Input = (
        loginIdText: Driver<String>,
        passwordText: Driver<String>,
        loginTap: Signal<Void>
    )
    
    var canSubmit: Driver<Bool> { get }
    var didErrorChange: Signal<Error> { get }
    
    func bind(input: Input)
    func loginTapped(id: String, password: String)
}

protocol LoginInteractorInterface: InteractorInterface {
    func login(id: String , password: String) -> Single<Result<Bool>>
    func saveUserInfo(_ userInfo: UserInfo) -> Single<Result<Bool>>
}

protocol LoginInteractorOutputInterface: InteractorOutputInterface {
}
