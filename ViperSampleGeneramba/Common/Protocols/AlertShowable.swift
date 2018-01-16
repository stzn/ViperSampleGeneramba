import UIKit

protocol AlertShowable {
    func showAlert(with title: String?, message: String?)
    func showErrorAlert(with message: String, handler: ((UIAlertAction) -> Void)?)
}

extension AlertShowable where Self: UIViewController {
    func showAlert(with title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(with: title, message: message, actions: [okAction])
    }
    
    func showErrorAlert(with message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        showAlert(with: "エラー", message: message, handler: handler)
    }
    
    func showAlert(with title: String?, message: String?, actions: [UIAlertAction]? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        
        if let _ = self.presentedViewController as? UIAlertController {
            return
        }
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        
        if let actions = actions {
            actions.forEach { action in
                controller.addAction(action)
            }
        } else {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
            controller.addAction(okAction)
        }
        
        self.present(controller, animated: true, completion: nil)
        
        return
    }
    
    func confirm(title: String, message: String, okTitle: String = "はい", cancelTitle: String = "いいえ", okHandler: ((UIAlertAction) -> Void)? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        
        guard let _ = self.presentedViewController as? UIAlertController else {
            return
        }

        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: okHandler)
        controller.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: cancelHandler)
        controller.addAction(cancelAction)
        
        self.present(controller, animated: true, completion: nil)
        return
    }
}
