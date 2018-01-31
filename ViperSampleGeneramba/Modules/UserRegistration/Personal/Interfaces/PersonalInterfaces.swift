import UIKit

protocol PersonalWireframeInterface: WireframeInterface {
    func goToNextStep(_ output: PersonalInformation?)
    func back()
}

protocol PersonalViewInterface: ViewInterface {
}

protocol PersonalPresenterInterface: PresenterInterface {
    func nextButtonTapped(name: String?, mailAddress: String?, address: String?)
    func backButtonTapped()
}

protocol PersonalInteractorInterface: InteractorInterface {
}

protocol PersonalInteractorOutputInterface: InteractorOutputInterface {
}

protocol PersonalAPIDataManagerInterface: DataManagerInterface {
}

protocol PersonalLocalDataManagerInterface: DataManagerInterface {
}
