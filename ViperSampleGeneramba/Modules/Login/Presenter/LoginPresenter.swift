import UIKit
import RxSwift
import RxCocoa

final class LoginPresenter {
    
    // MARK: - Public properties -
    
    var canSubmit: Driver<Bool> = Driver.empty()
    var didErrorChange: Signal<Error> = Signal.empty()
    
    
    // MARK: - Private properties -
    
    private var didErrorChangeRelay: PublishRelay<Error>?
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate weak var _view: LoginViewInterface?
    fileprivate let _interactor: LoginInteractorInterface
    fileprivate let _wireframe: LoginWireframeInterface
    
    // MARK: - Lifecycle -
    
    init(wireframe: LoginWireframeInterface, view: LoginViewInterface, interactor: LoginInteractorInterface) {
        
        _wireframe = wireframe
        _view = view
        _interactor = interactor
        
    }
    
    func bind(input: Input) {
        
        let didErrorChangeRelay = PublishRelay<Error>()
        self.didErrorChangeRelay = didErrorChangeRelay
        self.didErrorChange = didErrorChangeRelay.asSignal()
        
        let fields = Driver.combineLatest(
            input.loginIdText,
            input.passwordText,
            resultSelector: { ($0, $1) }
        )
        
        canSubmit = fields.map { (loginId, password) -> Bool in
            return !loginId.isEmpty && !password.isEmpty
            }
            .asDriver(onErrorDriveWith: .empty())
        
        input.loginTap.withLatestFrom(fields)
            .flatMapLatest { [weak self] (loginId, password) -> Signal<Void> in
                
                guard let `self` = self else { return Signal.empty() }
                
                guard !loginId.isEmpty && !password.isEmpty else {
                    didErrorChangeRelay.accept(ValidationError.loginRequired)
                    return Signal.empty()
                }
                
                self.loginTapped(id: loginId, password: password)
                
                self._view?.showLoading()
                
                return Signal.just(Void())
            }
            .emit()
            .disposed(by: disposeBag)
        
    }
}

// MARK: - Extensions -

extension LoginPresenter: LoginPresenterInterface {
    
    func loginTapped(id: String, password: String) {
        _interactor
            .login(id: id, password: password)
            .subscribe(onSuccess: { [weak self] result in
                
                guard let `self` = self else { return }
                
                guard let success = result.value else {
                    self.didErrorChangeRelay?.accept(ValidationError.loginFailed)
                    return
                }
                
                if !success {
                    self.didErrorChangeRelay?.accept(ValidationError.loginFailed)
                    return
                }
                self.loginSuceeded()
                
                }, onError: { [weak self] error in
                    
                    guard let `self` = self else { return }
                    
                    self.didErrorChangeRelay?.accept(OtherError.unexpected(error))
            })
            .disposed(by: disposeBag)
    }
}

extension LoginPresenter: LoginInteractorOutputInterface {
    
    private func loginSuceeded() {
        
        let userInfo = UserInfo(name: "Dummy")
        
        _interactor.saveUserInfo(userInfo).subscribe(
            onSuccess: { [weak self] _ in
                
                guard let `self` = self else { return }
                
                self.userInfoSaveSucceeded()
                
            }, onError: { [weak self] error in
                
                guard let `self` = self else { return }
                
                self.didErrorChangeRelay?.accept(OtherError.unexpected(error))
                
        }).disposed(by: disposeBag)
    }
    
    private func userInfoSaveSucceeded() {
        _view?.hideLoading()
        _wireframe.showMainScreen()
    }
}

