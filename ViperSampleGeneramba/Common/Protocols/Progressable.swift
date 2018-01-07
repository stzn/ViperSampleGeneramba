import UIKit

protocol Progressable {
    func showLoading()
    func showLoading(message: String)
    func hideLoading()
    func hideWithSuccess(message: String?)
    func hideWithError(message: String?)
}

extension Progressable where Self: UIViewController {
    
    func showLoading() {
        ActivityIndicator.shared.showAcitivityIndicator(view: self.view, message: "")
    }
    
    func showLoading(message: String) {
        ActivityIndicator.shared.showAcitivityIndicator(view: self.view, message: message)
    }
    
    func hideLoading() {
        ActivityIndicator.shared.hideActivityIndicator(view: self.view)
    }
    
    func hideWithSuccess(message: String?) {
        
        hideLoading()
        showLoading(message: message ?? "成功")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { [weak self] in
            self?.hideLoading()
        }
    }
    
    func hideWithError(message: String?) {
        hideLoading()
        showLoading(message: message ?? "エラー")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { [weak self] in
            self?.hideLoading()
        }
    }
}
