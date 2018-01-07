import UIKit

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Public properties -
    
    var presenter: LoginPresenterInterface!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        presenter.loginButtonTapped(id: idTextField.text ?? "", password: passwordTextField.text ?? "")
    }
}

// MARK: - Extensions -

extension LoginViewController {
    private func _setupUI() {
        idTextField.delegate = self
        passwordTextField.delegate = self
    }
}

extension LoginViewController: LoginViewInterface {
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

