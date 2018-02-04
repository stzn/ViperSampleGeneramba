import UIKit

final class AppFlowController: UIViewController {
    
    private let dependencyContainer: DependencyContainer
    
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        childViewControllers.first?.view.frame = view.bounds
    }
    
    func start() {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: UserDefaultsKeys.loggedIn) != nil {
            startMain()
        } else {
            startLogin()
        }
    }
    
    private func startLogin() {
        
        // Give dependency from DependencyContainer
        // to LoginDependencyContainer if needed
        let dependencyContainer = LoginDependencyContainer()
        
        let loginFlowController = LoginFlowController(dependencyContainer: dependencyContainer)
        
        loginFlowController.delegate = self
        add(childController: loginFlowController)
        loginFlowController.start()
    }
    
    private func startMain() {
        
        // Give dependency from DependencyContainer
        // to QiitaItemsDependencyContainer if needed
        let dependencyContainer = QiitaItemsDependencyContainer()
        
        let mainFlowController = QiitaItemsListFlowController(dependencyContainer: dependencyContainer)
        
        mainFlowController.delegate = self
        add(childController: mainFlowController)
        mainFlowController.start()
    }
    
    func logout() {
        removeUserInfo()
        if let flowController = childViewControllers.first {
            remove(childController: flowController)
        }
        startLogin()
    }

    private func removeUserInfo() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}

extension AppFlowController: LoginFlowControllerDelegate {
    
    func loginFlowControllerDidFinish(_ flowController: LoginFlowController) {
        remove(childController: flowController)
        startMain()
    }
}

extension AppFlowController: QiitaItemsListFlowControllerDelegate {
    func qiitaItemsListFlowControllerDidFinish(_ flowController: QiitaItemsListFlowController) {
        remove(childController: flowController)
        startLogin()
    }
}
