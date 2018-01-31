import UIKit

final class PersonalViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    // MARK: - Public properties -

    var presenter: PersonalPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "個人情報"
        let barButton = UIBarButtonItem(title: "次へ", style:  .plain, target: self, action: #selector(rightBarButtonTapped))
        self.navigationItem.rightBarButtonItem = barButton
        
        let backButton = UIBarButtonItem(title: "キャンセル", style:  .plain, target: self, action: #selector(backBarButtonTapped))
        
        self.navigationItem.leftBarButtonItem = backButton
    }
}

// MARK: - Extensions -


// MARK: - Setup -
extension PersonalViewController {
    
    private func _setupUI() {
        nameTextField.delegate = self
        mailAddressTextField.delegate = self
        addressTextField.delegate = self
        
        
    }
}

// MARK: - UserInteraction -
extension PersonalViewController {
    
    @objc func rightBarButtonTapped(_ sender: Any) {
        
        presenter.nextButtonTapped(
            name: nameTextField.text,
            mailAddress: mailAddressTextField.text,
            address: addressTextField.text
        )
    }
    
    @objc func backBarButtonTapped(_ sender: Any) {
        presenter.backButtonTapped()
    }
}

extension PersonalViewController: PersonalViewInterface {
}

extension PersonalViewController: StoryboardLoadable {
    static var storyboardName: String {
        return Storyboard.PersonalViewController.name
    }
}

extension PersonalViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

