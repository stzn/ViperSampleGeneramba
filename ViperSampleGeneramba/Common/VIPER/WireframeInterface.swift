import UIKit

protocol WireframeInterface: class {
    func showAlert(with title: String?, message: String?)
    func showErrorAlert(with message: String)
}

extension WireframeInterface {
    func showAlert(with title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(with: title, message: message, actions: [okAction])
    }
    
    func showErrorAlert(with message: String) {
        Alert.shared.alert(title: "エラー", message: message)
    }

    func showAlert(with title: String?, message: String?, actions: [UIAlertAction]) {
        
        Alert.shared.alert(title: "エラー", message: message ?? "", actions: actions)
    }
}
