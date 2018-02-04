import UIKit


protocol LoginViewControllerDelegate: class {
    func didLogin(_ controller: LoginViewController)
}

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var presenter: LoginPresenterInterface!
    weak var delegate: LoginViewControllerDelegate?
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        presenter.loginButtonTapped(id: idTextField.text, password: passwordTextField.text)
    }
}

extension LoginViewController {
    private func _setupUI() {
        idTextField.delegate = self
        passwordTextField.delegate = self
    }
}

extension LoginViewController: LoginViewInterface {
    func didLogin() {
        delegate?.didLogin(self)
    }
}

extension LoginViewController: StoryboardLoadable {
    static var storyboardName: String {
        return Storyboard.LoginViewController.name
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
