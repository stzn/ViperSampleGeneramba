import UIKit

protocol ConfirmationWireframeInterface: WireframeInterface {
    func finish()
    func back()
}

protocol ConfirmationViewInterface: ViewInterface {
}

protocol ConfirmationPresenterInterface: PresenterInterface {
    
    var userRegistraton: UserRegistration { get }
    func registerButtonTapped()
    func backButtonTapped()
}

protocol ConfirmationInteractorInterface: InteractorInterface {
}

protocol ConfirmationInteractorOutputInterface: InteractorOutputInterface {
}

protocol ConfirmationAPIDataManagerInterface: DataManagerInterface {
}

protocol ConfirmationLocalDataManagerInterface: DataManagerInterface {
}
