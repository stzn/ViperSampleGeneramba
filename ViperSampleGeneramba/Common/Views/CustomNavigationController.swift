import UIKit

final class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension CustomNavigationController {
    
    @objc func logout(_: UIBarButtonItem) {
        AppDelegate.shared.appFlowController.logout()
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
