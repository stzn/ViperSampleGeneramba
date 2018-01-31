import UIKit

final class ConfirmationViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailAddressLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var loginIdLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    // MARK: - Public properties -

    var presenter: ConfirmationPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "入力情報確認"
        let barButton = UIBarButtonItem(title: "登録", style:  .plain, target: self, action: #selector(registerButtonTapped))
        self.navigationItem.rightBarButtonItem = barButton
        
        let backButton = UIBarButtonItem(title: "戻る", style:  .plain, target: self, action: #selector(backBarButtonTapped))
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func registerButtonTapped(_ sender: Any) {
        presenter.registerButtonTapped()
    }
    
    @objc func backBarButtonTapped(_ sender: Any) {
        presenter.backButtonTapped()
    }
}

// MARK: - Extensions -
extension ConfirmationViewController {
    
    private func _setupUI() {
        
        let personal = presenter.userRegistraton.personal
        let login = presenter.userRegistraton.account
        let image = presenter.userRegistraton.profileImage
        
        nameLabel.text = personal.name
        mailAddressLabel.text = personal.mailAddress
        addressLabel.text = personal.address
        
        nicknameLabel.text = login.nickname
        loginIdLabel.text = login.loginId
        passwordLabel.text = login.password
        
        profileImageView.image = image
        
    }
}

extension ConfirmationViewController: ConfirmationViewInterface {
}

extension ConfirmationViewController: StoryboardLoadable {
    static var storyboardName: String {
        return Storyboard.ConfirmationViewController.name
    }
}

