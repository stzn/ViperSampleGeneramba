import UIKit

protocol AlertShowable {
    func showAlert(title: String?, message: String?)
    func showErrorAlert(message: String)
}

extension AlertShowable where Self: UIViewController {
    func showAlert(title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(title: title, message: message, actions: [okAction])
    }
    
    func showErrorAlert(message: String) {
        showAlert(title: "エラー", message: message)
    }
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        
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
    
    /// 確認表示
    func confirm(title: String, message: String, okTitle: String = "はい", cancelTitle: String = "いいえ", okHandler: ((UIAlertAction) -> Void)? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        
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

