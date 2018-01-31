import UIKit

protocol AccountWireframeInterface: WireframeInterface {
    func goToNextStep(_ output: AccountInformation?)
    func back()
}

protocol AccountViewInterface: ViewInterface {
}

protocol AccountPresenterInterface: PresenterInterface {
    func confirmButtonTapped(nickName: String?, loginId: String?, password: String?)
    func backButtonTapped()
}

protocol AccountInteractorInterface: InteractorInterface {
}

protocol AccountInteractorOutputInterface: InteractorOutputInterface {
}

protocol AccountAPIDataManagerInterface: DataManagerInterface {
}

protocol AccountLocalDataManagerInterface: DataManagerInterface {
}
