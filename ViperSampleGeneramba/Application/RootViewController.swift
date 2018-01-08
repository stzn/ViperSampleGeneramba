import UIKit

final class RootViewController: UIViewController {
    
    private var current: UIViewController
    
    init() {
        let wireFrame = SplashWireframe()
        current = wireFrame.configureModule()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParentViewController: self)
    }
    
    open override func childViewControllerForHomeIndicatorAutoHidden() -> UIViewController? {
        return self.childViewControllers.last
    }

    func showLoginScreen() {
        let wireFrame = LoginWireframe()
        let new = wireFrame.configureModule()
        
        new.view.frame = view.bounds
        view.addSubview(new.view)
        new.didMove(toParentViewController: self)
        
        current.willMove(toParentViewController: nil)
        current.view.removeFromSuperview()
        current.removeFromParentViewController()
        
        current = new
    }
    
    func showMainScreen() {
        let wireFrame = QiitaItemsListWireframe()
        let new = wireFrame.configureModule()
        
        addChildViewController(new)
        new.view.frame = view.bounds
        view.addSubview(new.view)
        new.didMove(toParentViewController: self)
        
        current.willMove(toParentViewController: nil)
        current.view.removeFromSuperview()
        current.removeFromParentViewController()
        
        current = new
    }
   
    func switchToMainScreen() {
        let wireFrame = QiitaItemsListWireframe()
        let new = wireFrame.configureModule()
        animateFadeTransition(to: new)
    }
    
    func logout() {
        
        removeUserInfo()

        let wireFrame = LoginWireframe()
        let new = wireFrame.configureModule()
        animateFadeTransition(to: new)
    }
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParentViewController: nil)
        addChildViewController(new)
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {}) { completed in
            
            self.current.removeFromParentViewController()
            new.didMove(toParentViewController: self)
            self.current = new
            completion?()
        }
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        
        let initailFrame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        current.willMove(toParentViewController: nil)
        addChildViewController(new)
        new.view.frame = initailFrame
        
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {}) { completed in
            
            self.current.removeFromParentViewController()
            new.didMove(toParentViewController: self)
            self.current = new
            completion?()
        }
    }
    
    private func removeUserInfo() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}

