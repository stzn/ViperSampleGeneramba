import UIKit

final class AccountViewController: UIViewController {

    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var loginIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Public properties -

    var presenter: AccountPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.title = "アカウント情報"
        let barButton = UIBarButtonItem(title: "次へ", style:  .plain, target: self, action: #selector(rightBarButtonTapped))
        self.navigationItem.rightBarButtonItem = barButton
        
        let backButton = UIBarButtonItem(title: "戻る", style:  .plain, target: self, action: #selector(backBarButtonTapped))

        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func rightBarButtonTapped(_ sender: Any) {
        presenter.confirmButtonTapped(
            nickName: nickNameTextField.text,
            loginId: loginIdTextField.text,
            password: passwordTextField.text
        )
    }
    
    @objc func backBarButtonTapped(_ sender: Any) {
        presenter.backButtonTapped()
    }
}

// MARK: - Extensions -

extension AccountViewController {
    private func _setupUI() {
        nickNameTextField.delegate = self
        loginIdTextField.delegate = self
        passwordTextField.delegate = self
        
    }
}

extension AccountViewController: AccountViewInterface {
}

extension AccountViewController: StoryboardLoadable {
    static var storyboardName: String {
        return Storyboard.AccountViewController.name
    }
}

extension AccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


