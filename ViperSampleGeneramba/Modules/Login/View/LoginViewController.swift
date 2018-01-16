import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Public properties -
    
    var presenter: LoginPresenterInterface!

    // MARK: - Private properties -

    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }    
}

// MARK: - Extensions -

extension LoginViewController {
    private func _setupUI() {
        idTextField.delegate = self
        passwordTextField.delegate = self
        
        presenter.bind(input: (
            loginIdText: idTextField.rx.text.orEmpty.asDriver(),
            passwordText: passwordTextField.rx.text.orEmpty.asDriver(),
            loginTap: loginButton.rx.tap.asSignal()
        ))
        
        presenter
            .canSubmit
            .drive(onNext: { enabled in
                self.loginButton.isEnabled = enabled
                self.loginButton.alpha = (enabled) ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)
        
        presenter
            .didErrorChange
            .emit(onNext: { [weak self] error in
                self?.hideLoading()
                self?.showAlert(with: "エラー", message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }    
}

extension LoginViewController: LoginViewInterface {
}

extension LoginViewController: StoryboardLoadable {
    static var storyboardName: String {
        return StoryboardName.LoginViewController.name
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

