import UIKit

final class PersonalPresenter {

    // MARK: - Private properties -

    fileprivate weak var _view: PersonalViewInterface?
    fileprivate var _interactor: PersonalInteractorInterface
    fileprivate var _wireframe: PersonalWireframeInterface

    // MARK: - Lifecycle -

    init(wireframe: PersonalWireframeInterface, view: PersonalViewInterface, interactor: PersonalInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }
}

// MARK: - Extensions -
extension PersonalPresenter: PersonalPresenterInterface {
    
    func nextButtonTapped(name: String?, mailAddress: String?, address: String?) {
        
        guard let name = validName(name) else { return }
        
        guard let mailAddress = validMailAddress(mailAddress) else { return }
        
        guard let address = validAddress(address) else { return }
        
        let personal = PersonalInformation(name: name, mailAddress: mailAddress, address: address)
        _wireframe.goToNextStep(personal)
    }
    
    func backButtonTapped() {
        _wireframe.back()
    }
    
    private func validName(_ name: String?) -> String? {
        
        let columnName = "名前"
        
        guard let name = name, !name.isEmpty else {
            showRequiredValidationError(columnName)
            return nil
        }
        return name
    }
    
    private func validMailAddress(_ mailAddress: String?) -> String? {
        
        let columnName = "メールアドレス"
        
        guard let mailAddress = mailAddress, !mailAddress.isEmpty else {
            showRequiredValidationError(columnName)
            return nil
        }
        return mailAddress
    }
    
    private func validAddress(_ address: String?) -> String? {
        
        let columnName = "住所"
        
        guard let address = address, !address.isEmpty else {
            showRequiredValidationError(columnName)
            return nil
        }
        return address
    }
    
    private func showRequiredValidationError(_ columnName: String) {
        _view?.showAlert(title: "エラー", message: columnName + "は必ず入力してください。")
    }
}

extension PersonalPresenter: PersonalInteractorOutputInterface {
}

