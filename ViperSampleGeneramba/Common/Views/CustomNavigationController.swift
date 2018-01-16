import UIKit

final class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension CustomNavigationController {
    
    @objc func logout(_: UIBarButtonItem) {
        removeUserInfo()
        let root = AppDelegate.shared.rootViewCotnroller
        root.logout()
    }
    
    private func removeUserInfo() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}

extension CustomNavigationController: UINavigationControllerDelegate {
    func navigationController(_: UINavigationController, didShow _: UIViewController, animated _: Bool) {
        
        setupButton()
    }
    
    private func setupButton() {
        
        let button = UIBarButtonItem(title: "ログアウト", style: .plain, target: self, action: #selector(logout(_:)))
        navigationBar.topItem!.rightBarButtonItem = button
    }
}
